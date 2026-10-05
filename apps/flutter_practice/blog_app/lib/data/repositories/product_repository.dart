import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/mock_data.dart';
import '../../core/errors/app_exception.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_constants.dart';
import '../../models/paginated_response.dart';
import '../../models/product.dart';

/// Thrown when attempting to delete a product that has existing order relationships (409 Conflict).
class ProductConflictException extends ConflictException {
  const ProductConflictException([
    super.message = 'Cannot delete product because it has associated orders.',
  ]);
}

class ProductRepository {
  final ApiClient _apiClient;

  ProductRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  /// Fetches paginated products envelope from FastAPI backend.
  /// Falls back gracefully to paginated MockData if backend is unreachable.
  Future<PaginatedResponse<Product>> getProductsPaged({
    String? category,
    int page = 1,
    int size = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'size': size};

      if (category != null &&
          category.isNotEmpty &&
          category.toLowerCase() != 'all') {
        queryParams['category'] = category.toLowerCase();
      }

      final response = await _apiClient.dio.get(
        ApiConstants.products,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final paged = PaginatedResponse.fromJson(
          data,
          (item) => Product.fromJson(item),
        );

        if (kDebugMode) {
          debugPrint(
            '☕ Successfully fetched page ${paged.page}/${paged.pages} (${paged.items.length}/${paged.total} products) from FastAPI backend.',
          );
        }

        return paged;
      }
    } on DioException catch (dioErr) {
      if (kDebugMode) {
        debugPrint(
          '⚠️ [FastAPI unreachable] Using fallback mock data: ${dioErr.message}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ [Error loading products] Using fallback mock data: $e');
      }
    }

    // Graceful offline fallback with pagination slicing
    List<Product> allFiltered = MockData.dailyProducts;
    if (category != null &&
        category.isNotEmpty &&
        category.toLowerCase() != 'all') {
      final cat = category.toLowerCase();
      allFiltered = MockData.dailyProducts.where((p) {
        final pCat = p.category.toLowerCase();
        return pCat == cat ||
            (cat == 'pastry' && pCat == 'bakery') ||
            (cat == 'bakery' && pCat == 'pastry');
      }).toList();
    }

    final total = allFiltered.length;
    final startIndex = (page - 1) * size;
    final pagedItems = (startIndex >= total || startIndex < 0)
        ? <Product>[]
        : allFiltered.skip(startIndex).take(size).toList();
    final pages = total == 0 ? 0 : (total / (size > 0 ? size : 1)).ceil();

    return PaginatedResponse<Product>(
      items: pagedItems,
      total: total,
      page: page,
      size: size,
      pages: pages,
    );
  }

  /// Fetches product list from FastAPI backend.
  /// Backward compatible wrapper delegating to [getProductsPaged].
  Future<List<Product>> getProducts({
    String? category,
    int page = 1,
    int size = 20,
  }) async {
    final paged = await getProductsPaged(
      category: category,
      page: page,
      size: size,
    );
    return paged.items;
  }

  /// Admin only: Creates a new product item via POST /api/v1/products.
  Future<Product> createProduct(Map<String, dynamic> payload) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.products,
        data: payload,
      );

      if (response.statusCode == 201 && response.data != null) {
        final product = Product.fromJson(response.data as Map<String, dynamic>);
        if (kDebugMode) {
          debugPrint(
            '✨ [Product Created]: ${product.name} (id: ${product.id})',
          );
        }
        return product;
      }
      throw Exception(
        'Failed to create product: unexpected response code ${response.statusCode}',
      );
    } on DioException catch (e) {
      final detail = _extractErrorMessage(e);
      if (kDebugMode) {
        debugPrint('❌ [createProduct DioException]: $detail');
      }
      throw Exception(detail);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ [createProduct Error]: $e');
      }
      rethrow;
    }
  }

  /// Admin only: Updates an existing product item via PUT /api/v1/products/{id}.
  Future<Product> updateProduct(String id, Map<String, dynamic> payload) async {
    try {
      final response = await _apiClient.dio.put(
        '${ApiConstants.products}/$id',
        data: payload,
      );

      if (response.statusCode == 200 && response.data != null) {
        final product = Product.fromJson(response.data as Map<String, dynamic>);
        if (kDebugMode) {
          debugPrint(
            '🔄 [Product Updated]: ${product.name} (id: ${product.id})',
          );
        }
        return product;
      }
      throw Exception(
        'Failed to update product: unexpected response code ${response.statusCode}',
      );
    } on DioException catch (e) {
      final detail = _extractErrorMessage(e);
      if (kDebugMode) {
        debugPrint('❌ [updateProduct DioException]: $detail');
      }
      throw Exception(detail);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ [updateProduct Error]: $e');
      }
      rethrow;
    }
  }

  /// Admin only: Permanently removes a product item via DELETE /api/v1/products/{id}.
  /// Throws [ProductConflictException] if product is referenced in existing order history (409 Conflict).
  Future<void> deleteProduct(String id) async {
    try {
      final response = await _apiClient.dio.delete(
        '${ApiConstants.products}/$id',
      );
      if (response.statusCode == 204 || response.statusCode == 200) {
        if (kDebugMode) {
          debugPrint('🗑️ [Product Deleted]: id $id');
        }
        return;
      }
      throw Exception(
        'Failed to delete product: unexpected response code ${response.statusCode}',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        final data = e.response?.data;
        final detail = data is Map
            ? data['detail']?.toString() ??
                  'Cannot delete product because it has associated orders.'
            : 'Cannot delete product because it has associated orders.';
        throw ProductConflictException(detail);
      }
      final detail = _extractErrorMessage(e);
      if (kDebugMode) {
        debugPrint('❌ [deleteProduct DioException]: $detail');
      }
      throw Exception(detail);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ [deleteProduct Error]: $e');
      }
      rethrow;
    }
  }

  /// Admin only: Uploads a product image file via POST /api/v1/uploads/image.
  /// Returns the publicly accessible URL of the uploaded image.
  Future<String> uploadImage(XFile file) async {
    try {
      final bytes = await file.readAsBytes();
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          bytes,
          filename: file.name.isNotEmpty ? file.name : 'upload.jpg',
        ),
      });

      final response = await _apiClient.dio.post(
        ApiConstants.uploadsImage,
        data: formData,
      );

      if (response.statusCode == 201 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final url = data['url'] as String? ?? '';
        if (kDebugMode) {
          debugPrint('📸 [Image Uploaded]: $url');
        }
        return url;
      }
      throw Exception('Unexpected server response: ${response.statusCode}');
    } on DioException catch (e) {
      final detail = _extractErrorMessage(e);
      if (kDebugMode) {
        debugPrint('❌ [uploadImage DioException]: $detail');
      }
      throw Exception(detail);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ [uploadImage Error]: $e');
      }
      rethrow;
    }
  }

  String _extractErrorMessage(DioException e) {
    if (e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map) {
        if (data['detail'] is String) {
          return data['detail'] as String;
        } else if (data['detail'] is List &&
            (data['detail'] as List).isNotEmpty) {
          final first = (data['detail'] as List).first;
          if (first is Map && first['msg'] != null) {
            return first['msg'].toString();
          }
          return data['detail'].toString();
        }
      }
    }
    return e.message ?? 'Cocoloco server connection error';
  }
}

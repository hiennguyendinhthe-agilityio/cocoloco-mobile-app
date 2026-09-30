import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/mock_data.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_constants.dart';
import '../../models/product.dart';

class ProductRepository {
  final ApiClient _apiClient = ApiClient();

  /// Fetches product list from FastAPI backend.
  /// Falls back gracefully to MockData if backend is unreachable.
  Future<List<Product>> getProducts({
    String? category,
    int page = 1,
    int size = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'size': size,
      };

      if (category != null && category.isNotEmpty && category.toLowerCase() != 'all') {
        queryParams['category'] = category.toLowerCase();
      }

      final response = await _apiClient.dio.get(
        ApiConstants.products,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final rawItems = data['items'] as List<dynamic>? ?? [];

        final products = rawItems
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();

        if (kDebugMode) {
          debugPrint('☕ Successfully fetched ${products.length} products from FastAPI backend.');
        }

        return products;
      }
    } on DioException catch (dioErr) {
      if (kDebugMode) {
        debugPrint('⚠️ [FastAPI unreachable] Using fallback mock data: ${dioErr.message}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ [Error loading products] Using fallback mock data: $e');
      }
    }

    // Graceful offline fallback
    if (category != null && category.isNotEmpty && category.toLowerCase() != 'all') {
      return MockData.dailyProducts
          .where((p) => p.category.toLowerCase() == category.toLowerCase())
          .toList();
    }
    return MockData.dailyProducts;
  }
}

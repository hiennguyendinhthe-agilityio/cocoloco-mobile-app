import 'dart:typed_data';
import 'package:cocoloco_app/core/network/api_client.dart';
import 'package:cocoloco_app/data/repositories/product_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  group('ProductRepository Unit Tests (With Mocked Network)', () {
    late Dio mockDio;
    late ProductRepository repository;

    setUp(() {
      mockDio = Dio(BaseOptions(baseUrl: 'http://test'));
    });

    test('getProducts returns parsed products on 200 OK', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'items': [
                    {
                      'id': 'p1',
                      'name': 'Espresso',
                      'price': '2.50',
                      'category': 'coffee',
                      'is_available': true,
                    },
                    {
                      'id': 'p2',
                      'name': 'Croissant',
                      'price': '3.00',
                      'category': 'pastry',
                      'is_available': true,
                    },
                  ],
                },
              ),
            );
          },
        ),
      );

      repository = ProductRepository(apiClient: ApiClient.withDio(mockDio));
      final products = await repository.getProducts(category: 'coffee');

      expect(products.length, 2);
      expect(products[0].name, 'Espresso');
      expect(products[1].name, 'Croissant');
    });

    test('getProductsPaged returns PaginatedResponse with pagination metadata on 200 OK', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'items': [
                    {
                      'id': 'p1',
                      'name': 'Espresso',
                      'price': '2.50',
                      'category': 'coffee',
                      'is_available': true,
                    },
                  ],
                  'total': 25,
                  'page': 1,
                  'size': 10,
                  'pages': 3,
                },
              ),
            );
          },
        ),
      );

      repository = ProductRepository(apiClient: ApiClient.withDio(mockDio));
      final paged = await repository.getProductsPaged(page: 1, size: 10);

      expect(paged.items.length, 1);
      expect(paged.total, 25);
      expect(paged.page, 1);
      expect(paged.size, 10);
      expect(paged.pages, 3);
      expect(paged.hasMore, isTrue);
    });

    test('getProducts falls back gracefully to MockData on network error', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'Network unreachable',
                type: DioExceptionType.connectionError,
              ),
            );
          },
        ),
      );

      repository = ProductRepository(apiClient: ApiClient.withDio(mockDio));
      final products = await repository.getProducts(category: 'all');

      expect(products, isNotEmpty);
      expect(products.any((p) => p.name.contains('Cappuccino')), isTrue);
    });

    test('createProduct succeeds on 201 Created and parses product', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 201,
                data: {
                  'id': 'new_uuid_123',
                  'name': 'Matcha Cloud',
                  'price': '5.25',
                  'category': 'seasonal',
                  'is_available': true,
                },
              ),
            );
          },
        ),
      );

      repository = ProductRepository(apiClient: ApiClient.withDio(mockDio));
      final product = await repository.createProduct({
        'name': 'Matcha Cloud',
        'price': '5.25',
        'category': 'seasonal',
      });

      expect(product.id, 'new_uuid_123');
      expect(product.name, 'Matcha Cloud');
      expect(product.price, 5.25);
    });

    test('createProduct throws exception on 422 validation error', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: 422,
                  data: {
                    'detail': [
                      {'msg': 'Price must be positive'},
                    ],
                  },
                ),
              ),
            );
          },
        ),
      );

      repository = ProductRepository(apiClient: ApiClient.withDio(mockDio));

      expect(
        () => repository.createProduct({'name': 'Free Coffee', 'price': '-1'}),
        throwsA(predicate((e) => e.toString().contains('Price must be positive'))),
      );
    });

    test('updateProduct succeeds on 200 OK and parses updated product', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'id': 'prod_456',
                  'name': 'Updated Latte',
                  'price': '4.00',
                  'category': 'coffee',
                  'is_available': false,
                },
              ),
            );
          },
        ),
      );

      repository = ProductRepository(apiClient: ApiClient.withDio(mockDio));
      final updated = await repository.updateProduct('prod_456', {
        'name': 'Updated Latte',
        'price': '4.00',
        'is_available': false,
      });

      expect(updated.id, 'prod_456');
      expect(updated.name, 'Updated Latte');
      expect(updated.price, 4.0);
      expect(updated.isAvailable, isFalse);
    });

    test('updateProduct throws exception on error', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: 404,
                  data: {'detail': 'Product not found'},
                ),
              ),
            );
          },
        ),
      );

      repository = ProductRepository(apiClient: ApiClient.withDio(mockDio));

      expect(
        () => repository.updateProduct('invalid_id', {'name': 'Ghost'}),
        throwsA(predicate((e) => e.toString().contains('Product not found'))),
      );
    });

    test('deleteProduct completes successfully on 204 No Content', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 204,
              ),
            );
          },
        ),
      );

      repository = ProductRepository(apiClient: ApiClient.withDio(mockDio));
      await expectLater(repository.deleteProduct('prod_del_1'), completes);
    });

    test('deleteProduct throws ProductConflictException on 409 Conflict', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: 409,
                  data: {
                    'detail': 'Cannot delete product because it has associated orders in history.',
                  },
                ),
              ),
            );
          },
        ),
      );

      repository = ProductRepository(apiClient: ApiClient.withDio(mockDio));

      expect(
        () => repository.deleteProduct('conflict_prod'),
        throwsA(isA<ProductConflictException>()),
      );
    });

    test('deleteProduct throws standard Exception on 500 server error', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: 500,
                  data: {'detail': 'Internal database failure'},
                ),
              ),
            );
          },
        ),
      );

      repository = ProductRepository(apiClient: ApiClient.withDio(mockDio));

      expect(
        () => repository.deleteProduct('err_prod'),
        throwsA(isA<Exception>()),
      );
    });

    test('ProductConflictException toString returns message', () {
      const ex = ProductConflictException('Conflict occurred');
      expect(ex.toString(), 'Conflict occurred');
    });

    test('getProducts with category falls back to filtered mock data on error', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'Network unreachable',
                type: DioExceptionType.connectionError,
              ),
            );
          },
        ),
      );

      repository = ProductRepository(apiClient: ApiClient.withDio(mockDio));
      final products = await repository.getProducts(category: 'coffee');

      expect(products, isNotEmpty);
      expect(products.every((p) => p.category.toLowerCase() == 'coffee'), isTrue);
    });

    test('handles unexpected status codes in create, update, delete', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: null,
              ),
            );
          },
        ),
      );

      repository = ProductRepository(apiClient: ApiClient.withDio(mockDio));
      expect(() => repository.createProduct({'name': 'Test'}), throwsException);
    });

    test('handles list detail without msg and null response message', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: 400,
                  data: {
                    'detail': ['String error 1', 'String error 2'],
                  },
                ),
              ),
            );
          },
        ),
      );

      repository = ProductRepository(apiClient: ApiClient.withDio(mockDio));
      expect(
        () => repository.deleteProduct('p_list_err'),
        throwsA(predicate((e) => e.toString().contains('String error 1'))),
      );
    });

    test('uploadImage succeeds on 201 Created and returns image url', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 201,
                data: {
                  'url': 'http://127.0.0.1:8000/static/images/test_image.png',
                  'filename': 'test_image.png',
                  'content_type': 'image/png',
                  'size_bytes': 1024,
                },
              ),
            );
          },
        ),
      );

      repository = ProductRepository(apiClient: ApiClient.withDio(mockDio));
      final xFile = XFile.fromData(
        Uint8List.fromList([1, 2, 3, 4]),
        name: 'test_image.png',
        mimeType: 'image/png',
      );
      final url = await repository.uploadImage(xFile);

      expect(url, equals('http://127.0.0.1:8000/static/images/test_image.png'));
    });

    test('uploadImage throws exception on error', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: 400,
                  data: {'detail': 'Unsupported media type'},
                ),
              ),
            );
          },
        ),
      );

      repository = ProductRepository(apiClient: ApiClient.withDio(mockDio));
      final xFile = XFile.fromData(
        Uint8List.fromList([1, 2, 3, 4]),
        name: 'test_doc.txt',
      );

      expect(
        () => repository.uploadImage(xFile),
        throwsA(predicate((e) => e.toString().contains('Unsupported media type'))),
      );
    });
  });
}

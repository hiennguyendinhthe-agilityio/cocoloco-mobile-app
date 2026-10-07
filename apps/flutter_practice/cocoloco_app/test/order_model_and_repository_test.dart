import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cocoloco_app/core/network/api_client.dart';
import 'package:cocoloco_app/core/services/session_service.dart';
import 'package:cocoloco_app/core/theme/tokens/cocoloco_theme_extension.dart';
import 'package:cocoloco_app/data/repositories/order_repository.dart';
import 'package:cocoloco_app/models/order.dart';
import 'package:cocoloco_app/models/user_profile.dart';

void main() {
  group('OrderItemModel Tests', () {
    test('fromJson parses full data correctly', () {
      final json = {
        'id': 'item-1',
        'product_id': 'prod-1',
        'product_name': 'Cold Brew',
        'quantity': 2,
        'unit_price': '4.50',
        'total_price': '9.00',
      };

      final item = OrderItemModel.fromJson(json);

      expect(item.id, 'item-1');
      expect(item.productId, 'prod-1');
      expect(item.productName, 'Cold Brew');
      expect(item.quantity, 2);
      expect(item.unitPrice, 4.50);
      expect(item.totalPrice, 9.00);
    });

    test('fromJson handles fallback defaults when fields are missing or null', () {
      final json = <String, dynamic>{};

      final item = OrderItemModel.fromJson(json);

      expect(item.id, '');
      expect(item.productId, '');
      expect(item.productName, 'Specialty Item');
      expect(item.quantity, 1);
      expect(item.unitPrice, 0.0);
      expect(item.totalPrice, 0.0);
    });

    test('fromJson uses subtotal if provided or falls back to unitPrice * quantity', () {
      final jsonWithSubtotal = {
        'unit_price': 5.0,
        'quantity': 3,
        'subtotal': '15.00',
      };
      final item1 = OrderItemModel.fromJson(jsonWithSubtotal);
      expect(item1.totalPrice, 15.00);

      final jsonWithoutSubtotal = {
        'unit_price': 5.0,
        'quantity': 3,
      };
      final item2 = OrderItemModel.fromJson(jsonWithoutSubtotal);
      expect(item2.totalPrice, 15.00);
    });
  });

  group('OrderModel Tests', () {
    test('fromJson parses full order with items and created_at', () {
      final json = {
        'id': 'ord-123456789',
        'user_id': 'usr-001',
        'status': 'confirmed',
        'total_amount': '12.50',
        'created_at': '2026-10-05T10:00:00Z',
        'items': [
          {
            'id': 'item-1',
            'product_id': 'prod-1',
            'product_name': 'Cappuccino',
            'quantity': 1,
            'unit_price': 4.5,
          }
        ],
      };

      final order = OrderModel.fromJson(json);

      expect(order.id, 'ord-123456789');
      expect(order.userId, 'usr-001');
      expect(order.status, 'CONFIRMED');
      expect(order.totalAmount, 12.50);
      expect(order.items.length, 1);
      expect(order.items.first.productName, 'Cappuccino');
      expect(order.formattedTotal, '\$12.50');
      expect(order.shortId, '#ORD-1234');
    });

    test('fromJson handles fallback defaults when dates and fields are missing', () {
      final json = <String, dynamic>{};
      final order = OrderModel.fromJson(json);

      expect(order.id, '');
      expect(order.userId, '');
      expect(order.status, 'PENDING');
      expect(order.totalAmount, 0.0);
      expect(order.items, isEmpty);
      expect(order.shortId, '#');
    });

    final fixedDate = DateTime(2026, 1, 1);

    test('shortId returns full id when length <= 8', () {
      final order = OrderModel(
        id: '12345',
        userId: 'u',
        status: 'PENDING',
        totalAmount: 10.0,
        createdAt: fixedDate,
        items: const [],
      );
      expect(order.shortId, '#12345');
    });

    test('statusLabel returns appropriate string for each status', () {
      expect(OrderModel(id: '', userId: '', status: 'CONFIRMED', totalAmount: 0, createdAt: fixedDate, items: const []).statusLabel, 'Brewing');
      expect(OrderModel(id: '', userId: '', status: 'COMPLETED', totalAmount: 0, createdAt: fixedDate, items: const []).statusLabel, 'Completed');
      expect(OrderModel(id: '', userId: '', status: 'CANCELLED', totalAmount: 0, createdAt: fixedDate, items: const []).statusLabel, 'Cancelled');
      expect(OrderModel(id: '', userId: '', status: 'PENDING', totalAmount: 0, createdAt: fixedDate, items: const []).statusLabel, 'Pending');
      expect(OrderModel(id: '', userId: '', status: 'UNKNOWN', totalAmount: 0, createdAt: fixedDate, items: const []).statusLabel, 'Pending');
    });

    test('statusBgColor and statusTextColor return fallback AppPalette colors', () {
      for (final status in ['CONFIRMED', 'COMPLETED', 'CANCELLED', 'PENDING', 'OTHER']) {
        final order = OrderModel(id: '', userId: '', status: status, totalAmount: 0, createdAt: fixedDate, items: const []);
        expect(order.statusBgColor, isA<Color>());
        expect(order.statusTextColor, isA<Color>());
      }
    });

    testWidgets('getStatusBgColor and getStatusTextColor resolve custom theme extension if present', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light().copyWith(
            extensions: const [
              CocolocoCustomTheme.light,
            ],
          ),
          home: Builder(
            builder: (context) {
              final pending = OrderModel(id: '', userId: '', status: 'PENDING', totalAmount: 0, createdAt: fixedDate, items: const []);
              expect(pending.getStatusBgColor(context), CocolocoCustomTheme.light.statusPendingBg);
              expect(pending.getStatusTextColor(context), CocolocoCustomTheme.light.statusPendingText);

              final confirmed = OrderModel(id: '', userId: '', status: 'CONFIRMED', totalAmount: 0, createdAt: fixedDate, items: const []);
              expect(confirmed.getStatusBgColor(context), CocolocoCustomTheme.light.statusConfirmedBg);
              expect(confirmed.getStatusTextColor(context), CocolocoCustomTheme.light.statusConfirmedText);

              final completed = OrderModel(id: '', userId: '', status: 'COMPLETED', totalAmount: 0, createdAt: fixedDate, items: const []);
              expect(completed.getStatusBgColor(context), CocolocoCustomTheme.light.statusCompletedBg);
              expect(completed.getStatusTextColor(context), CocolocoCustomTheme.light.statusCompletedText);

              final cancelled = OrderModel(id: '', userId: '', status: 'CANCELLED', totalAmount: 0, createdAt: fixedDate, items: const []);
              expect(cancelled.getStatusBgColor(context), CocolocoCustomTheme.light.statusCancelledBg);
              expect(cancelled.getStatusTextColor(context), CocolocoCustomTheme.light.statusCancelledText);

              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('OrderRepository Unit Tests (With Mocked Network)', () {
    late Dio mockDio;
    late OrderRepository repository;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      mockDio = Dio(BaseOptions(baseUrl: 'http://test'));
      final client = ApiClient.withDio(mockDio);
      ApiClient.instance = client;
      repository = OrderRepository(apiClient: client);
    });

    tearDown(() {
      ApiClient.resetInstance();
    });

    test('createOrder posts item payload and returns OrderModel on 200 OK', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'id': 'ord-test-created',
                  'user_id': 'usr-test',
                  'status': 'PENDING',
                  'total_amount': '9.00',
                  'items': [
                    {
                      'id': 'item-1',
                      'product_id': 'prod-1',
                      'product_name': 'Latte',
                      'quantity': 2,
                      'unit_price': 4.5,
                      'total_price': 9.0,
                    }
                  ],
                },
              ),
            );
          },
        ),
      );

      final order = await repository.createOrder(items: [
        {'product_id': 'prod-1', 'quantity': 2}
      ]);

      expect(order.id, 'ord-test-created');
      expect(order.totalAmount, 9.00);
      expect(order.items.length, 1);
    });

    test('createOrder rethrows DioException on failure', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: 400,
                  data: {'detail': 'Invalid product quantity'},
                ),
              ),
            );
          },
        ),
      );

      expect(
        () => repository.createOrder(items: []),
        throwsA(isA<DioException>()),
      );
    });

    test('getMyOrders returns empty list when user is not logged in', () async {
      await SessionService.instance.logout();

      final orders = await repository.getMyOrders();
      expect(orders, isEmpty);
    });

    test('getMyOrders returns list of orders when logged in and 200 OK', () async {
      await SessionService.instance.loginAs(AppRole.user);

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
                      'id': 'ord-my-1',
                      'user_id': 'usr-1',
                      'status': 'COMPLETED',
                      'total_amount': 5.0,
                    }
                  ]
                },
              ),
            );
          },
        ),
      );

      final orders = await repository.getMyOrders();
      expect(orders.length, 1);
      expect(orders.first.id, 'ord-my-1');
      expect(orders.first.status, 'COMPLETED');
    });

    test('getMyOrders returns empty list gracefully on network exception', () async {
      await SessionService.instance.loginAs(AppRole.user);

      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.reject(
              DioException(requestOptions: options),
            );
          },
        ),
      );

      final orders = await repository.getMyOrders();
      expect(orders, isEmpty);
    });

    test('getAllOrders returns list on 200 OK', () async {
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
                      'id': 'ord-all-1',
                      'user_id': 'usr-any',
                      'status': 'PENDING',
                      'total_amount': 15.0,
                    }
                  ]
                },
              ),
            );
          },
        ),
      );

      final orders = await repository.getAllOrders();
      expect(orders.length, 1);
      expect(orders.first.id, 'ord-all-1');
    });

    test('getAllOrders returns empty list gracefully on exception', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.reject(
              DioException(requestOptions: options),
            );
          },
        ),
      );

      final orders = await repository.getAllOrders();
      expect(orders, isEmpty);
    });

    test('updateOrderStatus calls PATCH and updates status successfully', () async {
      // First seed a local order via createOrder
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.method == 'POST') {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'id': 'ord-to-update',
                    'user_id': 'usr-1',
                    'status': 'PENDING',
                    'total_amount': '10.0',
                    'items': [],
                  },
                ),
              );
            }
            if (options.method == 'PATCH') {
              return handler.resolve(
                Response(requestOptions: options, statusCode: 200, data: {'success': true}),
              );
            }
            return handler.next(options);
          },
        ),
      );

      final created = await repository.createOrder(items: []);
      expect(created.status, 'PENDING');

      final success = await repository.updateOrderStatus('ord-to-update', 'COMPLETED');
      expect(success, isTrue);
    });

    test('updateOrderStatus returns false on error', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.reject(DioException(requestOptions: options));
          },
        ),
      );

      final result = await repository.updateOrderStatus('fake-id', 'COMPLETED');
      expect(result, isFalse);
    });
  });
}

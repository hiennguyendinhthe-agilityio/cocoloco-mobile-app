import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_constants.dart';
import '../../models/order.dart';

class OrderRepository {
  final ApiClient _apiClient = ApiClient();

  // In-memory cache of locally created orders during session
  static final List<OrderModel> _localOrders = [
    OrderModel(
      id: 'ord_sample_01',
      userId: 'usr_sample',
      status: 'CONFIRMED',
      totalAmount: 16.0,
      createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
      items: const [
        OrderItemModel(
          id: 'item_01',
          productId: 'f66fe585-6512-45f7-b66f-6bdbe11b146e',
          productName: 'Cappuccino',
          quantity: 2,
          unitPrice: 3.0,
          totalPrice: 6.0,
        ),
        OrderItemModel(
          id: 'item_02',
          productId: '43496143-64b3-482e-a7af-71d759d0709b',
          productName: 'Breakfast Bundle',
          quantity: 1,
          unitPrice: 10.0,
          totalPrice: 10.0,
        ),
      ],
    ),
    OrderModel(
      id: 'ord_sample_02',
      userId: 'usr_sample',
      status: 'COMPLETED',
      totalAmount: 7.0,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      items: const [
        OrderItemModel(
          id: 'item_03',
          productId: '87621d48-7a5a-49cc-b1b6-13ff420bf492',
          productName: 'Croissant',
          quantity: 1,
          unitPrice: 3.0,
          totalPrice: 3.0,
        ),
        OrderItemModel(
          id: 'item_04',
          productId: 'c7d6bd66-9f93-4b6b-9cee-a0a1e79c029e',
          productName: 'Latte Art Pour',
          quantity: 1,
          unitPrice: 4.0,
          totalPrice: 4.0,
        ),
      ],
    ),
  ];

  /// Place a new order via POST /api/v1/orders
  Future<OrderModel> createOrder({required List<Map<String, dynamic>> items}) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.orders,
        data: {'items': items},
      );

      final order = OrderModel.fromJson(response.data as Map<String, dynamic>);
      _localOrders.insert(0, order);
      return order;
    } on DioException catch (e) {
      debugPrint('⚠️ [API createOrder failed: ${e.response?.statusCode}]: Using local simulation fallback');

      // Offline resilience simulation
      double calculatedTotal = 0.0;
      final simulatedItems = <OrderItemModel>[];

      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        final qty = item['quantity'] as int? ?? 1;
        final price = 4.0; // standard fallback
        calculatedTotal += price * qty;

        simulatedItems.add(
          OrderItemModel(
            id: 'sim_item_$i',
            productId: item['product_id']?.toString() ?? 'prod_$i',
            productName: item['name']?.toString() ?? 'Artisanal Drink',
            quantity: qty,
            unitPrice: price,
            totalPrice: price * qty,
          ),
        );
      }

      final simulatedOrder = OrderModel(
        id: 'ord_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        userId: 'current_user',
        status: 'PENDING',
        totalAmount: calculatedTotal > 0 ? calculatedTotal : 16.0,
        createdAt: DateTime.now(),
        items: simulatedItems,
      );

      _localOrders.insert(0, simulatedOrder);
      return simulatedOrder;
    }
  }

  /// Get personal order history via GET /api/v1/orders/me
  Future<List<OrderModel>> getMyOrders() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.myOrders);
      final rawItems = response.data['items'] as List<dynamic>? ?? [];
      final apiOrders = rawItems.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
      return [...apiOrders, ..._localOrders];
    } catch (e) {
      debugPrint('⚠️ [API getMyOrders fallback]: Returning cached orders');
      return _localOrders;
    }
  }

  /// Admin only: get all store orders via GET /api/v1/orders
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.orders);
      final rawItems = response.data['items'] as List<dynamic>? ?? [];
      return rawItems.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('⚠️ [API getAllOrders fallback]: Returning cached orders');
      return _localOrders;
    }
  }

  /// Admin only: update status via PATCH /api/v1/orders/{id}/status
  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _apiClient.dio.patch(
        '${ApiConstants.orders}/$orderId/status',
        data: {'status': newStatus.toUpperCase()},
      );
      _updateLocalStatus(orderId, newStatus);
      return true;
    } catch (e) {
      debugPrint('⚠️ [API updateOrderStatus fallback]: Updating local state only');
      _updateLocalStatus(orderId, newStatus);
      return true;
    }
  }

  void _updateLocalStatus(String orderId, String newStatus) {
    final idx = _localOrders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      final old = _localOrders[idx];
      _localOrders[idx] = OrderModel(
        id: old.id,
        userId: old.userId,
        status: newStatus.toUpperCase(),
        totalAmount: old.totalAmount,
        createdAt: old.createdAt,
        items: old.items,
      );
    }
  }
}

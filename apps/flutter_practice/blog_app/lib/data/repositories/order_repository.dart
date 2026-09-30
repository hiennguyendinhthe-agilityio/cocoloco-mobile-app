import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_constants.dart';
import '../../core/services/session_service.dart';
import '../../models/order.dart';

class OrderRepository {
  final ApiClient _apiClient;

  OrderRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  // In-memory cache of locally created orders during session
  static final List<OrderModel> _localOrders = [];

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
      debugPrint('❌ [API createOrder failed: ${e.response?.statusCode}]: ${e.response?.data ?? e.message}');
      // Strictly rethrow to adhere to Rule 03: Never simulate success on failure
      rethrow;
    }
  }

  /// Get personal order history via GET /api/v1/orders/me
  Future<List<OrderModel>> getMyOrders() async {
    if (!SessionService.instance.isLoggedIn) {
      return [];
    }
    try {
      final response = await _apiClient.dio.get(ApiConstants.myOrders);
      final rawItems = response.data['items'] as List<dynamic>? ?? [];
      final apiOrders = rawItems.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
      return apiOrders;
    } catch (e) {
      debugPrint('⚠️ [API getMyOrders error]: $e');
      return [];
    }
  }

  /// Admin only: get all store orders via GET /api/v1/orders
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.orders);
      final rawItems = response.data['items'] as List<dynamic>? ?? [];
      return rawItems.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('⚠️ [API getAllOrders error]: $e');
      return [];
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
      debugPrint('❌ [API updateOrderStatus failed]: $e');
      return false;
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

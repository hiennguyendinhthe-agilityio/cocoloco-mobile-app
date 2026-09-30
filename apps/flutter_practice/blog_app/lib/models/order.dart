import 'package:flutter/material.dart';

class OrderItemModel {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  const OrderItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String? ?? '',
      productId: json['product_id'] as String? ?? '',
      productName: json['product_name'] as String? ?? 'Specialty Item',
      quantity: json['quantity'] as int? ?? 1,
      unitPrice: double.tryParse(json['unit_price']?.toString() ?? '0.0') ?? 0.0,
      totalPrice: double.tryParse(json['total_price']?.toString() ?? '0.0') ?? 0.0,
    );
  }
}

class OrderModel {
  final String id;
  final String userId;
  final String status; // 'PENDING', 'CONFIRMED', 'COMPLETED', 'CANCELLED'
  final double totalAmount;
  final DateTime createdAt;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final itemsRaw = json['items'] as List<dynamic>? ?? [];
    return OrderModel(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      status: (json['status'] as String? ?? 'PENDING').toUpperCase(),
      totalAmount: double.tryParse(json['total_amount']?.toString() ?? '0.0') ?? 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      items: itemsRaw.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  String get shortId => id.length > 8 ? '#${id.substring(0, 8).toUpperCase()}' : '#$id';

  String get statusLabel {
    switch (status) {
      case 'CONFIRMED':
        return 'Brewing';
      case 'COMPLETED':
        return 'Completed';
      case 'CANCELLED':
        return 'Cancelled';
      case 'PENDING':
      default:
        return 'Pending';
    }
  }

  Color get statusBgColor {
    switch (status) {
      case 'CONFIRMED':
        return const Color(0xFFE8F1FC);
      case 'COMPLETED':
        return const Color(0xFFEAF8ED);
      case 'CANCELLED':
        return const Color(0xFFFDEEEC);
      case 'PENDING':
      default:
        return const Color(0xFFFFF7E6);
    }
  }

  Color get statusTextColor {
    switch (status) {
      case 'CONFIRMED':
        return const Color(0xFF2B6CB0);
      case 'COMPLETED':
        return const Color(0xFF2E7D32);
      case 'CANCELLED':
        return const Color(0xFFC53030);
      case 'PENDING':
      default:
        return const Color(0xFFD97706);
    }
  }

  String get formattedTotal => '\$${totalAmount.toStringAsFixed(2)}';
}

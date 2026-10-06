import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme/tokens/app_primitives.dart';
import '../core/theme/tokens/cocoloco_theme_extension.dart';

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
    final qty = json['quantity'] as int? ?? 1;
    final unitPrice = double.tryParse(json['unit_price']?.toString() ?? '0.0') ?? 0.0;
    final subtotal = double.tryParse(json['subtotal']?.toString() ?? json['total_price']?.toString() ?? '') ?? (unitPrice * qty);

    return OrderItemModel(
      id: json['id'] as String? ?? '',
      productId: json['product_id'] as String? ?? '',
      productName: json['product_name'] as String? ?? 'Specialty Item',
      quantity: qty,
      unitPrice: unitPrice,
      totalPrice: subtotal,
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
    final dateStr = json['ordered_at']?.toString() ?? json['created_at']?.toString();
    return OrderModel(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      status: (json['status'] as String? ?? 'PENDING').toUpperCase(),
      totalAmount: double.tryParse(json['total_amount']?.toString() ?? '0.0') ?? 0.0,
      createdAt: dateStr != null
          ? DateTime.tryParse(dateStr)?.toLocal() ?? DateTime.now()
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
        return AppPalette.statusConfirmedBg;
      case 'COMPLETED':
        return AppPalette.statusCompletedBg;
      case 'CANCELLED':
        return AppPalette.statusCancelledBg;
      case 'PENDING':
      default:
        return AppPalette.statusPendingBg;
    }
  }

  Color get statusTextColor {
    switch (status) {
      case 'CONFIRMED':
        return AppPalette.statusConfirmedText;
      case 'COMPLETED':
        return AppPalette.statusCompletedText;
      case 'CANCELLED':
        return AppPalette.statusCancelledText;
      case 'PENDING':
      default:
        return AppPalette.statusPendingText;
    }
  }

  Color getStatusBgColor(BuildContext context) {
    final customTheme = Theme.of(context).extension<CocolocoCustomTheme>();
    if (customTheme == null) return statusBgColor;
    switch (status) {
      case 'CONFIRMED':
        return customTheme.statusConfirmedBg;
      case 'COMPLETED':
        return customTheme.statusCompletedBg;
      case 'CANCELLED':
        return customTheme.statusCancelledBg;
      case 'PENDING':
      default:
        return customTheme.statusPendingBg;
    }
  }

  Color getStatusTextColor(BuildContext context) {
    final customTheme = Theme.of(context).extension<CocolocoCustomTheme>();
    if (customTheme == null) return statusTextColor;
    switch (status) {
      case 'CONFIRMED':
        return customTheme.statusConfirmedText;
      case 'COMPLETED':
        return customTheme.statusCompletedText;
      case 'CANCELLED':
        return customTheme.statusCancelledText;
      case 'PENDING':
      default:
        return customTheme.statusPendingText;
    }
  }

  String get formattedTotal => '\$${totalAmount.toStringAsFixed(2)}';

  String get formattedDateTime => DateFormat('MMM dd, hh:mm a').format(createdAt);

  OrderModel copyWith({
    String? id,
    String? userId,
    String? status,
    double? totalAmount,
    DateTime? createdAt,
    List<OrderItemModel>? items,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
    );
  }
}

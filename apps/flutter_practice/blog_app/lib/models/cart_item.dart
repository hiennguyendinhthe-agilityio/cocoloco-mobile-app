import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

@immutable
class CartItem {
  final String id;
  final String productId;
  final String name;
  final String customization;
  final int quantity;
  final double price;
  final Color titleColor;

  const CartItem({
    required this.id,
    required this.productId,
    required this.name,
    this.customization = 'Standard',
    this.quantity = 1,
    required this.price,
    this.titleColor = AppColors.primary,
  }) : assert(quantity > 0, 'Quantity must be at least 1');

  double get totalPrice => price * quantity;

  CartItem copyWith({
    String? id,
    String? productId,
    String? name,
    String? customization,
    int? quantity,
    double? price,
    Color? titleColor,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      customization: customization ?? this.customization,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      titleColor: titleColor ?? this.titleColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          productId == other.productId &&
          quantity == other.quantity &&
          price == other.price;

  @override
  int get hashCode => id.hashCode ^ productId.hashCode ^ quantity.hashCode ^ price.hashCode;
}

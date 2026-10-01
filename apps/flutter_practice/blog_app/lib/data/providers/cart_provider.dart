import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/cart_item.dart';
import '../../models/order.dart';
import '../../models/product.dart';
import '../repositories/order_repository.dart';

@immutable
class CartState {
  final List<CartItem> items;
  final bool isSubmitting;
  final String? errorMessage;

  const CartState({
    this.items = const [],
    this.isSubmitting = false,
    this.errorMessage,
  });

  bool get isEmpty => items.isEmpty;
  int get totalItemCount => items.fold(0, (sum, i) => sum + i.quantity);

  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee => isEmpty ? 0.0 : 2.0;

  double get total => subtotal + deliveryFee;

  /// Aggregates items by productId to satisfy FastAPI unique product constraint
  List<Map<String, dynamic>> toOrderPayload() {
    final Map<String, int> aggregatedQuantities = {};
    for (final item in items) {
      aggregatedQuantities[item.productId] =
          (aggregatedQuantities[item.productId] ?? 0) + item.quantity;
    }
    return aggregatedQuantities.entries
        .map((e) => {
              'product_id': e.key,
              'quantity': e.value,
            })
        .toList();
  }

  CartState copyWith({
    List<CartItem>? items,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CartState(
      items: items ?? this.items,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() {
    return const CartState();
  }

  void addProduct(
    Product product, {
    int quantity = 1,
    String? customization,
    double? price,
  }) {
    if (quantity <= 0) return;

    final existingIndex = state.items.indexWhere((i) => i.productId == product.id);
    if (existingIndex != -1) {
      final existingItem = state.items[existingIndex];
      final updatedList = List<CartItem>.from(state.items);
      updatedList[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
        customization: customization ?? existingItem.customization,
        price: price ?? existingItem.price,
      );
      state = state.copyWith(items: updatedList, clearError: true);
    } else {
      final newItem = CartItem(
        id: product.id,
        productId: product.id,
        name: product.name,
        customization: customization ?? 'Standard',
        quantity: quantity,
        price: price ?? product.price,
        titleColor: product.titleColor,
      );
      state = state.copyWith(items: [...state.items, newItem], clearError: true);
    }
  }

  /// Sets the exact quantity and customization for a product (avoids blind accumulation).
  void setOrUpdateProduct(
    Product product, {
    required int quantity,
    String? customization,
    double? price,
  }) {
    if (quantity <= 0) {
      removeItem(product.id);
      return;
    }

    final existingIndex = state.items.indexWhere((i) => i.productId == product.id);
    if (existingIndex != -1) {
      final existingItem = state.items[existingIndex];
      final updatedList = List<CartItem>.from(state.items);
      updatedList[existingIndex] = existingItem.copyWith(
        quantity: quantity,
        customization: customization ?? existingItem.customization,
        price: price ?? existingItem.price,
      );
      state = state.copyWith(items: updatedList, clearError: true);
    } else {
      final newItem = CartItem(
        id: product.id,
        productId: product.id,
        name: product.name,
        customization: customization ?? 'Standard',
        quantity: quantity,
        price: price ?? product.price,
        titleColor: product.titleColor,
      );
      state = state.copyWith(items: [...state.items, newItem], clearError: true);
    }
  }

  void updateQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(itemId);
      return;
    }

    final updatedList = state.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedList, clearError: true);
  }

  void removeItem(String itemId) {
    final updatedList = state.items.where((i) => i.id != itemId).toList();
    state = state.copyWith(items: updatedList, clearError: true);
  }

  void clearCart() {
    state = const CartState(items: [], isSubmitting: false, errorMessage: null);
  }

  Future<OrderModel?> checkout(OrderRepository orderRepository) async {
    if (state.isEmpty) return null;

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final payload = state.toOrderPayload();
      final order = await orderRepository.createOrder(items: payload);

      // Order succeeded: clear cart and reset submission state
      state = const CartState(items: [], isSubmitting: false, errorMessage: null);
      return order;
    } catch (e) {
      debugPrint('❌ [CartNotifier] Order checkout failed: $e');
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Checkout failed. Please check your connection and try again.',
      );
      return null;
    }
  }
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(() {
  return CartNotifier();
});

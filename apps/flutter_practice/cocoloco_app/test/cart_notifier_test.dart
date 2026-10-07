import 'package:flutter_test/flutter_test.dart';
import 'package:cocoloco_app/data/providers/cart_provider.dart';
import 'package:cocoloco_app/data/repositories/order_repository.dart';
import 'package:cocoloco_app/models/cart_item.dart';
import 'package:cocoloco_app/models/order.dart';
import 'package:cocoloco_app/models/product.dart';
import 'package:cocoloco_app/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MockFailingOrderRepository extends OrderRepository {
  @override
  Future<OrderModel> createOrder({required List<Map<String, dynamic>> items}) async {
    throw Exception('Connection refused');
  }
}

class MockSucceedingOrderRepository extends OrderRepository {
  @override
  Future<OrderModel> createOrder({required List<Map<String, dynamic>> items}) async {
    return OrderModel(
      id: 'ord_test_success_123',
      userId: 'user_test_uuid',
      status: 'PENDING',
      totalAmount: 18.0,
      createdAt: DateTime.now(),
      items: const [],
    );
  }
}

void main() {
  group('CartState & Business Calculations (Pure Dart)', () {
    test('Calculates subtotal, delivery fee and total correctly', () {
      const state = CartState(
        items: [
          CartItem(
            id: 'item_1',
            productId: 'f66fe585-6512-45f7-b66f-6bdbe11b146e',
            name: 'Cappuccino',
            quantity: 3,
            price: 4.5,
          ),
          CartItem(
            id: 'item_2',
            productId: '87621d48-7a5a-49cc-b1b6-13ff420bf492',
            name: 'Croissant',
            quantity: 2,
            price: 3.0,
          ),
        ],
      );

      // Subtotal: 3 * 4.5 + 2 * 3.0 = 13.5 + 6.0 = 19.5
      expect(state.subtotal, equals(19.5));
      // Delivery fee when non-empty is 2.0
      expect(state.deliveryFee, equals(2.0));
      // Total: 19.5 + 2.0 = 21.5
      expect(state.total, equals(21.5));
      expect(state.totalItemCount, equals(5));
      expect(state.isEmpty, isFalse);
    });

    test('Empty cart has 0 subtotal, 0 delivery fee, and 0 total', () {
      const emptyState = CartState(items: []);
      expect(emptyState.subtotal, equals(0.0));
      expect(emptyState.deliveryFee, equals(0.0));
      expect(emptyState.total, equals(0.0));
      expect(emptyState.totalItemCount, equals(0));
      expect(emptyState.isEmpty, isTrue);
    });

    test('toOrderPayload aggregates items by productId to satisfy FastAPI constraint', () {
      const state = CartState(
        items: [
          CartItem(
            id: 'item_1a',
            productId: 'prod_uuid_cappuccino',
            name: 'Cappuccino Cup 1',
            quantity: 2,
            price: 4.0,
          ),
          CartItem(
            id: 'item_1b',
            productId: 'prod_uuid_cappuccino',
            name: 'Cappuccino Cup 2 (Extra oat milk)',
            quantity: 3,
            price: 4.0,
          ),
          CartItem(
            id: 'item_2',
            productId: 'prod_uuid_croissant',
            name: 'Croissant',
            quantity: 1,
            price: 3.5,
          ),
        ],
      );

      final payload = state.toOrderPayload();
      expect(payload.length, equals(2));

      final cappuccinoEntry =
          payload.firstWhere((p) => p['product_id'] == 'prod_uuid_cappuccino');
      expect(cappuccinoEntry['quantity'], equals(5));

      final croissantEntry =
          payload.firstWhere((p) => p['product_id'] == 'prod_uuid_croissant');
      expect(croissantEntry['quantity'], equals(1));
    });
  });

  group('CartNotifier State Transitions', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    const testProduct = Product(
      id: 'f66fe585-6512-45f7-b66f-6bdbe11b146e',
      name: 'Cappuccino',
      description: 'Test coffee',
      price: 4.0,
      priceDisplay: r'$4',
      imageAsset: 'assets/images/cappuccino.png',
      category: 'coffee',
      titleColor: AppColors.cappuccinoPink,
    );

    test('Initial cart state is empty', () {
      expect(container.read(cartProvider).isEmpty, isTrue);
      expect(container.read(cartProvider).totalItemCount, equals(0));
    });

    test('addProduct adds new product or increments existing', () {
      final notifier = container.read(cartProvider.notifier);

      notifier.addProduct(testProduct, quantity: 2);
      expect(container.read(cartProvider).items.length, equals(1));
      expect(container.read(cartProvider).items.first.quantity, equals(2));

      // Adding the same product should increment quantity
      notifier.addProduct(testProduct, quantity: 1);
      expect(container.read(cartProvider).items.length, equals(1));
      expect(container.read(cartProvider).items.first.quantity, equals(3));
    });

    test('updateQuantity updates item quantity or removes if <= 0', () {
      final notifier = container.read(cartProvider.notifier);
      notifier.addProduct(testProduct, quantity: 2);
      final firstItemId = container.read(cartProvider).items.first.id;

      notifier.updateQuantity(firstItemId, 5);
      expect(
        container
            .read(cartProvider)
            .items
            .firstWhere((i) => i.id == firstItemId)
            .quantity,
        equals(5),
      );

      // Decrementing to 0 should remove item
      notifier.updateQuantity(firstItemId, 0);
      expect(
        container.read(cartProvider).items.any((i) => i.id == firstItemId),
        isFalse,
      );
    });

    test('checkout failure sets errorMessage and DOES NOT clear items (No Fake Success)', () async {
      final notifier = container.read(cartProvider.notifier);
      notifier.addProduct(testProduct, quantity: 2);
      expect(container.read(cartProvider).items.length, equals(1));

      final mockFailingRepo = MockFailingOrderRepository();
      final resultOrder = await notifier.checkout(mockFailingRepo);

      // Must NOT return order
      expect(resultOrder, isNull);

      final stateAfterFailure = container.read(cartProvider);
      // Must NOT have cleared the cart
      expect(stateAfterFailure.items.length, equals(1));
      // Must NOT be submitting
      expect(stateAfterFailure.isSubmitting, isFalse);
      // Must have informative error message
      expect(stateAfterFailure.errorMessage, isNotNull);
    });

    test('checkout success clears cart and returns OrderModel', () async {
      final notifier = container.read(cartProvider.notifier);
      notifier.addProduct(testProduct, quantity: 2);
      expect(container.read(cartProvider).items.length, equals(1));

      final mockSucceedingRepo = MockSucceedingOrderRepository();
      final resultOrder = await notifier.checkout(mockSucceedingRepo);

      expect(resultOrder, isNotNull);
      expect(resultOrder!.id, equals('ord_test_success_123'));

      final stateAfterSuccess = container.read(cartProvider);
      expect(stateAfterSuccess.isEmpty, isTrue);
      expect(stateAfterSuccess.errorMessage, isNull);
    });

    test('removeItem removes product by id', () {
      final notifier = container.read(cartProvider.notifier);
      notifier.addProduct(testProduct, quantity: 2);
      expect(container.read(cartProvider).items.length, equals(1));

      notifier.removeItem(testProduct.id);
      expect(container.read(cartProvider).items.isEmpty, isTrue);
    });

    test('restoreItem restores removed item at original index for Undo operation', () {
      final notifier = container.read(cartProvider.notifier);
      const secondProduct = Product(
        id: '87621d48-7a5a-49cc-b1b6-13ff420bf492',
        name: 'Croissant',
        description: 'Test pastry',
        price: 3.0,
        priceDisplay: r'$3',
        imageAsset: 'assets/images/croissant.png',
        category: 'bakery',
        titleColor: AppColors.croissantBlue,
      );

      notifier.addProduct(testProduct, quantity: 1); // index 0
      notifier.addProduct(secondProduct, quantity: 2); // index 1
      expect(container.read(cartProvider).items.length, equals(2));

      final removedItem = container.read(cartProvider).items.first; // Cappuccino at 0
      notifier.removeItem(removedItem.id);
      expect(container.read(cartProvider).items.length, equals(1));
      expect(container.read(cartProvider).items.first.name, equals('Croissant'));

      // Undo: Restore Cappuccino back at index 0
      notifier.restoreItem(removedItem, index: 0);
      final restoredItems = container.read(cartProvider).items;
      expect(restoredItems.length, equals(2));
      expect(restoredItems[0].name, equals('Cappuccino'));
      expect(restoredItems[0].quantity, equals(1));
      expect(restoredItems[1].name, equals('Croissant'));
    });

    test('setOrUpdateProduct with quantity 0 removes product from cart', () {
      final notifier = container.read(cartProvider.notifier);
      notifier.addProduct(testProduct, quantity: 3);
      expect(container.read(cartProvider).items.length, equals(1));

      notifier.setOrUpdateProduct(testProduct, quantity: 0);
      expect(container.read(cartProvider).items.isEmpty, isTrue);
    });
  });
}

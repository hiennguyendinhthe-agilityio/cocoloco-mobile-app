import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blog_app/data/providers/orders_provider.dart';
import 'package:blog_app/core/providers/network_providers.dart';
import 'package:blog_app/core/services/session_service.dart';
import 'package:blog_app/models/user_profile.dart';
import 'package:blog_app/data/repositories/order_repository.dart';
import 'package:blog_app/models/order.dart';

class MockOrderRepository extends OrderRepository {
  List<OrderModel> ordersToReturn;
  bool shouldThrow;

  MockOrderRepository({this.ordersToReturn = const [], this.shouldThrow = false});

  @override
  Future<List<OrderModel>> getMyOrders() async {
    if (shouldThrow) {
      throw Exception('Server error');
    }
    return ordersToReturn;
  }
}

void main() {
  final sampleOrder1 = OrderModel(
    id: 'ord_1',
    userId: 'usr_1',
    status: 'PENDING',
    totalAmount: 10.0,
    createdAt: DateTime(2026, 1, 1),
    items: const [],
  );

  final sampleOrder2 = OrderModel(
    id: 'ord_2',
    userId: 'usr_1',
    status: 'COMPLETED',
    totalAmount: 25.0,
    createdAt: DateTime(2026, 1, 2),
    items: const [],
  );

  group('OrdersState Filtering', () {
    test('filteredOrders returns all orders when filter is ALL', () {
      final state = OrdersState(orders: [sampleOrder1, sampleOrder2], selectedFilter: 'ALL');
      expect(state.filteredOrders.length, equals(2));
    });

    test('filteredOrders filters by status correctly', () {
      final state = OrdersState(orders: [sampleOrder1, sampleOrder2], selectedFilter: 'PENDING');
      expect(state.filteredOrders.length, equals(1));
      expect(state.filteredOrders.first.id, equals('ord_1'));
    });
  });

  group('OrdersNotifier State Transitions', () {
    test('addOrder prepends order without duplicates', () {
      final container = ProviderContainer(
        overrides: [
          orderRepositoryProvider.overrideWithValue(MockOrderRepository()),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(ordersProvider.notifier);
      expect(container.read(ordersProvider).orders, isEmpty);

      notifier.addOrder(sampleOrder1);
      expect(container.read(ordersProvider).orders.length, equals(1));
      expect(container.read(ordersProvider).orders.first.id, equals('ord_1'));

      // Prepending another order
      notifier.addOrder(sampleOrder2);
      expect(container.read(ordersProvider).orders.length, equals(2));
      expect(container.read(ordersProvider).orders.first.id, equals('ord_2'));

      // Re-adding same order should be ignored
      notifier.addOrder(sampleOrder1);
      expect(container.read(ordersProvider).orders.length, equals(2));
    });

    test('loadOrders sets empty if session is not logged in', () async {
      SessionService.instance.logout();

      final container = ProviderContainer(
        overrides: [
          orderRepositoryProvider.overrideWithValue(MockOrderRepository(ordersToReturn: [sampleOrder1])),
        ],
      );
      addTearDown(container.dispose);

      await container.read(ordersProvider.notifier).loadOrders();
      expect(container.read(ordersProvider).orders, isEmpty);
    });

    test('loadOrders populates orders when logged in', () async {
      SessionService.instance.loginAs(AppRole.user);

      final container = ProviderContainer(
        overrides: [
          orderRepositoryProvider.overrideWithValue(
            MockOrderRepository(ordersToReturn: [sampleOrder1, sampleOrder2]),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(ordersProvider.notifier).loadOrders();
      expect(container.read(ordersProvider).orders.length, equals(2));
      expect(container.read(ordersProvider).isLoading, isFalse);

      SessionService.instance.logout();
    });

    test('loadOrders handles error and sets errorMessage', () async {
      SessionService.instance.loginAs(AppRole.user);

      final container = ProviderContainer(
        overrides: [
          orderRepositoryProvider.overrideWithValue(
            MockOrderRepository(shouldThrow: true),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(ordersProvider.notifier).loadOrders();
      expect(container.read(ordersProvider).errorMessage, isNotNull);
      expect(container.read(ordersProvider).isLoading, isFalse);

      SessionService.instance.logout();
    });
  });
}

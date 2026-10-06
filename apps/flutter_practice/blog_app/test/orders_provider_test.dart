import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blog_app/data/providers/orders_provider.dart';
import 'package:blog_app/core/providers/network_providers.dart';
import 'package:blog_app/core/services/session_service.dart';
import 'package:blog_app/models/user_profile.dart';
import 'package:blog_app/data/repositories/order_repository.dart';
import 'package:blog_app/models/order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockOrderRepository extends OrderRepository {
  List<OrderModel> ordersToReturn;
  bool shouldThrow;
  bool updateStatusSuccess;
  String? lastUpdatedOrderId;
  String? lastUpdatedStatus;

  MockOrderRepository({
    this.ordersToReturn = const [],
    this.shouldThrow = false,
    this.updateStatusSuccess = true,
  });

  @override
  Future<List<OrderModel>> getMyOrders() async {
    if (shouldThrow) {
      throw Exception('Server error');
    }
    return ordersToReturn;
  }

  @override
  Future<List<OrderModel>> getAllOrders() async {
    if (shouldThrow) {
      throw Exception('Server error');
    }
    return ordersToReturn;
  }

  @override
  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    lastUpdatedOrderId = orderId;
    lastUpdatedStatus = newStatus;
    return updateStatusSuccess;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

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

  group('AdminOrdersNotifier Optimistic UI & Lifecycle', () {
    test('loadOrders populates all store orders', () async {
      final mockRepo = MockOrderRepository(ordersToReturn: [sampleOrder1, sampleOrder2]);
      final container = ProviderContainer(
        overrides: [
          orderRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(adminOrdersProvider.notifier).loadOrders();
      final state = container.read(adminOrdersProvider);
      expect(state.orders.length, equals(2));
      expect(state.isLoading, isFalse);
    });

    test('updateOrderStatus performs optimistic update and succeeds', () async {
      final mockRepo = MockOrderRepository(ordersToReturn: [sampleOrder1, sampleOrder2]);
      final container = ProviderContainer(
        overrides: [
          orderRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(adminOrdersProvider.notifier).loadOrders();
      expect(container.read(adminOrdersProvider).orders.first.status, equals('PENDING'));

      final success = await container.read(adminOrdersProvider.notifier).updateOrderStatus('ord_1', 'CONFIRMED');
      expect(success, isTrue);
      expect(container.read(adminOrdersProvider).orders.first.status, equals('CONFIRMED'));
      expect(mockRepo.lastUpdatedOrderId, equals('ord_1'));
      expect(mockRepo.lastUpdatedStatus, equals('CONFIRMED'));
    });

    test('updateOrderStatus rolls back state on network failure', () async {
      final mockRepo = MockOrderRepository(ordersToReturn: [sampleOrder1]);
      mockRepo.updateStatusSuccess = false;

      final container = ProviderContainer(
        overrides: [
          orderRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(adminOrdersProvider.notifier).loadOrders();
      expect(container.read(adminOrdersProvider).orders.first.status, equals('PENDING'));

      final success = await container.read(adminOrdersProvider.notifier).updateOrderStatus('ord_1', 'COMPLETED');
      expect(success, isFalse);
      // Rolled back to original status
      expect(container.read(adminOrdersProvider).orders.first.status, equals('PENDING'));
      expect(container.read(adminOrdersProvider).errorMessage, isNotNull);
    });

    test('dismissOrder and clearCompleted filter out finished orders from shift view', () async {
      final mockRepo = MockOrderRepository(ordersToReturn: [sampleOrder1, sampleOrder2]);
      final container = ProviderContainer(
        overrides: [
          orderRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(adminOrdersProvider.notifier).loadOrders();
      final notifier = container.read(adminOrdersProvider.notifier);

      // Default filter is ACTIVE (only sampleOrder1 is PENDING)
      expect(container.read(adminOrdersProvider).filteredOrders.length, equals(1));
      expect(container.read(adminOrdersProvider).activeCount, equals(1));

      // Switch to ALL
      notifier.setFilter('ALL');
      expect(container.read(adminOrdersProvider).filteredOrders.length, equals(2));

      // Dismiss sampleOrder1
      notifier.dismissOrder('ord_1');
      expect(container.read(adminOrdersProvider).filteredOrders.length, equals(1));
      expect(container.read(adminOrdersProvider).filteredOrders.first.id, equals('ord_2'));

      // Clear completed
      notifier.clearCompleted();
      expect(container.read(adminOrdersProvider).filteredOrders, isEmpty);

      // Restore all
      notifier.restoreAllDismissed();
      expect(container.read(adminOrdersProvider).filteredOrders.length, equals(2));
    });
  });

  group('User Orders Soft-Hide Feature', () {
    test('hideOrder removes order from filtered list and unhideOrder restores it', () async {
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
      expect(container.read(ordersProvider).filteredOrders.length, equals(2));
      expect(container.read(ordersProvider).totalVisibleCount, equals(2));

      // Hide sampleOrder1
      await container.read(ordersProvider.notifier).hideOrder('ord_1');
      expect(container.read(ordersProvider).filteredOrders.length, equals(1));
      expect(container.read(ordersProvider).filteredOrders.first.id, equals('ord_2'));
      expect(container.read(ordersProvider).totalVisibleCount, equals(1));

      // Unhide sampleOrder1
      await container.read(ordersProvider.notifier).unhideOrder('ord_1');
      expect(container.read(ordersProvider).filteredOrders.length, equals(2));
      expect(container.read(ordersProvider).totalVisibleCount, equals(2));

      SessionService.instance.logout();
    });
  });
}

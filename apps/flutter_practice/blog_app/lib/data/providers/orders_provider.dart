import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/network_providers.dart';
import '../../models/order.dart';
import '../repositories/order_repository.dart';

@immutable
class OrdersState {
  final List<OrderModel> orders;
  final bool isLoading;
  final String? errorMessage;
  final String selectedFilter;

  const OrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.errorMessage,
    this.selectedFilter = 'ALL',
  });

  List<OrderModel> get filteredOrders {
    if (selectedFilter == 'ALL') return orders;
    return orders.where((o) => o.status == selectedFilter).toList();
  }

  OrdersState copyWith({
    List<OrderModel>? orders,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    String? selectedFilter,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}

class OrdersNotifier extends Notifier<OrdersState> {
  @override
  OrdersState build() {
    final session = ref.watch(sessionServiceProvider);

    void onSessionChange() {
      if (session.isLoggedIn) {
        loadOrders();
      } else {
        state = state.copyWith(orders: [], isLoading: false, clearError: true);
      }
    }

    session.addListener(onSessionChange);
    ref.onDispose(() {
      session.removeListener(onSessionChange);
    });

    if (session.isLoggedIn) {
      // Asynchronously fetch initial order list
      Future.microtask(() => loadOrders());
    }

    return const OrdersState();
  }

  OrderRepository get _orderRepository => ref.read(orderRepositoryProvider);

  /// Fetch user orders from GET /api/v1/orders/me
  Future<void> loadOrders() async {
    final session = ref.read(sessionServiceProvider);
    if (!session.isLoggedIn) {
      state = state.copyWith(orders: [], isLoading: false, clearError: true);
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final orders = await _orderRepository.getMyOrders();
      state = state.copyWith(
        orders: orders,
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      debugPrint('❌ [OrdersNotifier] loadOrders error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Could not load orders. Please try again.',
      );
    }
  }

  /// Proactively insert a newly created order at the top of the list
  void addOrder(OrderModel newOrder) {
    final exists = state.orders.any((o) => o.id == newOrder.id);
    if (!exists) {
      state = state.copyWith(
        orders: [newOrder, ...state.orders],
        clearError: true,
      );
    }
  }

  /// Change active filter chip ('ALL', 'PENDING', 'CONFIRMED', 'COMPLETED')
  void setFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  /// Pull-to-refresh handler
  Future<void> refresh() async {
    await loadOrders();
  }
}

final ordersProvider = NotifierProvider<OrdersNotifier, OrdersState>(() {
  return OrdersNotifier();
});

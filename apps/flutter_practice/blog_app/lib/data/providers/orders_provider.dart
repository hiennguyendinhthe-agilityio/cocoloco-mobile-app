import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/providers/network_providers.dart';
import '../../models/order.dart';
import '../repositories/order_repository.dart';

@immutable
class OrdersState {
  final List<OrderModel> orders;
  final bool isLoading;
  final String? errorMessage;
  final String selectedFilter;
  final Set<String> hiddenOrderIds;

  const OrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.errorMessage,
    this.selectedFilter = 'ALL',
    this.hiddenOrderIds = const {},
  });

  /// Orders filtered by status and excluding user-hidden orders
  List<OrderModel> get filteredOrders {
    final visible = orders.where((o) => !hiddenOrderIds.contains(o.id)).toList();
    if (selectedFilter == 'ALL') return visible;
    return visible.where((o) => o.status == selectedFilter).toList();
  }

  int get totalVisibleCount => orders.where((o) => !hiddenOrderIds.contains(o.id)).length;

  OrdersState copyWith({
    List<OrderModel>? orders,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    String? selectedFilter,
    Set<String>? hiddenOrderIds,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedFilter: selectedFilter ?? this.selectedFilter,
      hiddenOrderIds: hiddenOrderIds ?? this.hiddenOrderIds,
    );
  }
}

class OrdersNotifier extends Notifier<OrdersState> {
  static const String _hiddenOrdersPrefKey = 'cocoloco_user_hidden_orders';

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

    // Restore user hidden orders
    Future.microtask(() => _loadHiddenOrders());

    if (session.isLoggedIn) {
      // Asynchronously fetch initial order list
      Future.microtask(() => loadOrders());
    }

    return const OrdersState();
  }

  OrderRepository get _orderRepository => ref.read(orderRepositoryProvider);

  Future<void> _loadHiddenOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_hiddenOrdersPrefKey) ?? [];
      if (list.isNotEmpty) {
        state = state.copyWith(hiddenOrderIds: list.toSet());
      }
    } catch (e) {
      debugPrint('⚠️ [OrdersNotifier] Error loading hidden orders: $e');
    }
  }

  /// Soft-hide an order from user view and persist in local storage
  Future<void> hideOrder(String orderId) async {
    final updated = {...state.hiddenOrderIds, orderId};
    state = state.copyWith(hiddenOrderIds: updated);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_hiddenOrdersPrefKey, updated.toList());
    } catch (e) {
      debugPrint('⚠️ [OrdersNotifier] Error persisting hidden orders: $e');
    }
  }

  /// Unhide/undo hiding an order
  Future<void> unhideOrder(String orderId) async {
    final updated = state.hiddenOrderIds.where((id) => id != orderId).toSet();
    state = state.copyWith(hiddenOrderIds: updated);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_hiddenOrdersPrefKey, updated.toList());
    } catch (e) {
      debugPrint('⚠️ [OrdersNotifier] Error reverting hidden orders: $e');
    }
  }

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

@immutable
class AdminOrdersState {
  final List<OrderModel> orders;
  final bool isLoading;
  final String? updatingOrderId;
  final String? errorMessage;
  final String selectedFilter; // 'ACTIVE', 'COMPLETED', 'ALL', 'CANCELLED'
  final Set<String> dismissedOrderIds;

  const AdminOrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.updatingOrderId,
    this.errorMessage,
    this.selectedFilter = 'ACTIVE',
    this.dismissedOrderIds = const {},
  });

  /// Filtered orders based on selected filter and excluding dismissed shift items
  List<OrderModel> get filteredOrders {
    final visible = orders.where((o) => !dismissedOrderIds.contains(o.id)).toList();
    switch (selectedFilter) {
      case 'ACTIVE':
        return visible.where((o) => o.status == 'PENDING' || o.status == 'CONFIRMED').toList();
      case 'COMPLETED':
        return visible.where((o) => o.status == 'COMPLETED').toList();
      case 'CANCELLED':
        return visible.where((o) => o.status == 'CANCELLED').toList();
      case 'ALL':
      default:
        return visible;
    }
  }

  int get activeCount => orders.where((o) => !dismissedOrderIds.contains(o.id) && (o.status == 'PENDING' || o.status == 'CONFIRMED')).length;
  int get completedCount => orders.where((o) => !dismissedOrderIds.contains(o.id) && o.status == 'COMPLETED').length;
  int get cancelledCount => orders.where((o) => !dismissedOrderIds.contains(o.id) && o.status == 'CANCELLED').length;
  int get allCount => orders.where((o) => !dismissedOrderIds.contains(o.id)).length;

  AdminOrdersState copyWith({
    List<OrderModel>? orders,
    bool? isLoading,
    String? updatingOrderId,
    bool clearUpdating = false,
    String? errorMessage,
    bool clearError = false,
    String? selectedFilter,
    Set<String>? dismissedOrderIds,
  }) {
    return AdminOrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      updatingOrderId: clearUpdating ? null : (updatingOrderId ?? this.updatingOrderId),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedFilter: selectedFilter ?? this.selectedFilter,
      dismissedOrderIds: dismissedOrderIds ?? this.dismissedOrderIds,
    );
  }
}

class AdminOrdersNotifier extends Notifier<AdminOrdersState> {
  @override
  AdminOrdersState build() {
    return const AdminOrdersState();
  }

  OrderRepository get _orderRepository => ref.read(orderRepositoryProvider);

  /// Change active tab filter ('ACTIVE', 'COMPLETED', 'ALL', 'CANCELLED')
  void setFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  /// Dismiss an order from the active shift view without modifying database records
  void dismissOrder(String orderId) {
    state = state.copyWith(
      dismissedOrderIds: {...state.dismissedOrderIds, orderId},
    );
  }

  /// Clear all completed orders from the current shift view
  void clearCompleted() {
    final completedIds = state.orders
        .where((o) => o.status == 'COMPLETED')
        .map((o) => o.id);
    state = state.copyWith(
      dismissedOrderIds: {...state.dismissedOrderIds, ...completedIds},
    );
  }

  /// Restore all dismissed orders back into view
  void restoreAllDismissed() {
    state = state.copyWith(dismissedOrderIds: const {});
  }

  /// Fetch all store orders via GET /api/v1/orders
  Future<void> loadOrders() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final orders = await _orderRepository.getAllOrders();
      state = state.copyWith(orders: orders, isLoading: false, clearError: true);
    } catch (e) {
      debugPrint('❌ [AdminOrdersNotifier] loadOrders error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Could not load store orders. Please try again.',
      );
    }
  }

  /// Optimistically update status and sync with backend PATCH /api/v1/orders/{id}/status
  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    final prevOrders = state.orders;

    // 1. In-place optimistic UI update (0ms latency, eliminates flicker)
    final updatedList = state.orders.map((ord) {
      if (ord.id == orderId) {
        return ord.copyWith(status: newStatus.toUpperCase());
      }
      return ord;
    }).toList();

    state = state.copyWith(
      orders: updatedList,
      updatingOrderId: orderId,
      clearError: true,
    );

    // 2. Network call to backend
    final success = await _orderRepository.updateOrderStatus(orderId, newStatus);
    if (!success) {
      // Rollback on failure
      state = state.copyWith(
        orders: prevOrders,
        clearUpdating: true,
        errorMessage: 'Failed to update order status. Reverted.',
      );
      return false;
    }

    state = state.copyWith(clearUpdating: true);
    return true;
  }
}

final adminOrdersProvider = NotifierProvider<AdminOrdersNotifier, AdminOrdersState>(() {
  return AdminOrdersNotifier();
});

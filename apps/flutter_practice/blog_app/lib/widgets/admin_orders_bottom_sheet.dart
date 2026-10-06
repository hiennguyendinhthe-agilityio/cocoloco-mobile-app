import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../data/providers/orders_provider.dart';
import '../models/order.dart';

class AdminOrdersBottomSheet extends ConsumerStatefulWidget {
  const AdminOrdersBottomSheet({super.key});

  @override
  ConsumerState<AdminOrdersBottomSheet> createState() => _AdminOrdersBottomSheetState();
}

class _AdminOrdersBottomSheetState extends ConsumerState<AdminOrdersBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminOrdersProvider.notifier).loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminOrdersProvider);

    // Listen for error messages and display transient SnackBar
    ref.listen<AdminOrdersState>(adminOrdersProvider, (prev, next) {
      if (next.errorMessage != null && next.errorMessage != prev?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: context.colorScheme.error,
          ),
        );
      }
    });

    final filteredOrders = state.filteredOrders;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (_, scrollController) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and ADMIN HUB badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Store Orders',
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'ADMIN HUB',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: context.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Manage preparation lifecycle & shift orders',
                      style: TextStyle(fontSize: 13, color: context.colorScheme.onSurfaceVariant),
                    ),
                  ),
                  if (state.completedCount > 0 &&
                      (state.selectedFilter == 'COMPLETED' || state.selectedFilter == 'ALL')) ...[
                    InkWell(
                      onTap: () {
                        ref.read(adminOrdersProvider.notifier).clearCompleted();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cleared completed orders from current shift view.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.cleaning_services_rounded,
                              size: 14,
                              color: context.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Clear Done',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: context.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else if (state.dismissedOrderIds.isNotEmpty) ...[
                    InkWell(
                      onTap: () {
                        ref.read(adminOrdersProvider.notifier).restoreAllDismissed();
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.replay_rounded,
                              size: 14,
                              color: context.colorScheme.secondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Restore All',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: context.colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),

              // Filter Tabs (Active, Completed, All, Cancelled)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildFilterChip('ACTIVE', 'Active (${state.activeCount})', Icons.hourglass_top_rounded),
                    const SizedBox(width: 8),
                    _buildFilterChip('COMPLETED', 'Completed (${state.completedCount})', Icons.check_circle_outline_rounded),
                    const SizedBox(width: 8),
                    _buildFilterChip('ALL', 'All (${state.allCount})', Icons.list_alt_rounded),
                    const SizedBox(width: 8),
                    _buildFilterChip('CANCELLED', 'Cancelled (${state.cancelledCount})', Icons.cancel_outlined),
                  ],
                ),
              ),
              Divider(height: 24, color: context.colorScheme.outlineVariant),

              // Order List Content
              Expanded(
                child: state.isLoading && state.orders.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(color: context.colorScheme.primary),
                      )
                    : filteredOrders.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  state.selectedFilter == 'ACTIVE'
                                      ? Icons.celebration_rounded
                                      : Icons.inbox_rounded,
                                  size: 40,
                                  color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  state.selectedFilter == 'ACTIVE'
                                      ? 'No active orders waiting. All caught up!'
                                      : state.selectedFilter == 'COMPLETED'
                                          ? 'No completed orders in this shift.'
                                          : 'No orders found.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: context.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            color: context.colorScheme.primary,
                            onRefresh: () => ref.read(adminOrdersProvider.notifier).loadOrders(),
                            child: ListView.separated(
                              controller: scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: filteredOrders.length,
                              separatorBuilder: (_, _) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final ord = filteredOrders[index];
                                final isUpdating = state.updatingOrderId == ord.id;
                                return _buildAdminOrderRow(ord, isUpdating);
                              },
                            ),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String filterKey, String label, IconData icon) {
    final state = ref.watch(adminOrdersProvider);
    final isSelected = state.selectedFilter == filterKey;

    return InkWell(
      onTap: () {
        ref.read(adminOrdersProvider.notifier).setFilter(filterKey);
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colorScheme.primary
              : context.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? context.colorScheme.primary
                : context.colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected
                  ? context.colorScheme.onPrimary
                  : context.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected
                    ? context.colorScheme.onPrimary
                    : context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminOrderRow(OrderModel ord, bool isUpdating) {
    final isFinished = ord.status == 'COMPLETED' || ord.status == 'CANCELLED';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Short ID + Total & Status Popup Menu + Dismiss Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${ord.shortId} • \$${ord.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: context.colorScheme.onSurface,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PopupMenuButton<String>(
                    initialValue: ord.status,
                    enabled: !isUpdating,
                    onSelected: (newStatus) {
                      ref.read(adminOrdersProvider.notifier).updateOrderStatus(ord.id, newStatus);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: ord.statusBgColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isUpdating) ...[
                            SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: ord.statusTextColor,
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          Text(
                            ord.statusLabel,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: ord.statusTextColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_drop_down, size: 16, color: ord.statusTextColor),
                        ],
                      ),
                    ),
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'PENDING', child: Text('⏳ PENDING (Pending)')),
                      PopupMenuItem(value: 'CONFIRMED', child: Text('☕ CONFIRMED (Brewing)')),
                      PopupMenuItem(value: 'COMPLETED', child: Text('✅ COMPLETED (Done)')),
                      PopupMenuItem(value: 'CANCELLED', child: Text('❌ CANCELLED (Cancelled)')),
                    ],
                  ),
                  if (isFinished) ...[
                    const SizedBox(width: 6),
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        size: 17,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'Dismiss from shift view',
                      onPressed: () {
                        ref.read(adminOrdersProvider.notifier).dismissOrder(ord.id);
                      },
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),

          // Row 2: Date & Time of Order
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 13,
                color: context.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 5),
              Text(
                ord.formattedDateTime,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Row 3: Items list
          Text(
            ord.items.isNotEmpty
                ? ord.items.map((i) => '${i.quantity}x ${i.productName}').join(', ')
                : 'No line items',
            style: TextStyle(fontSize: 13, color: context.colorScheme.onSurfaceVariant),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

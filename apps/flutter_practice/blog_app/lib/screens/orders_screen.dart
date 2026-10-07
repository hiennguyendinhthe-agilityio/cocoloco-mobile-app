import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../core/localization/app_localizations.dart';
import '../core/services/session_service.dart';
import '../core/theme/app_theme.dart';
import '../data/providers/orders_provider.dart';
import '../models/order.dart';
import 'clerk_webview_screen.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  final List<String>? cartItems;
  final double? totalAmount;
  final VoidCallback? onClearCart;

  const OrdersScreen({
    super.key,
    this.cartItems,
    this.totalAmount,
    this.onClearCart,
  });

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  List<Map<String, String>> _getStatusFilters(BuildContext context) {
    final l10n = context.l10n;
    return [
      {'id': 'ALL', 'label': l10n.allOrders},
      {'id': 'PENDING', 'label': '⏳ ${l10n.pending}'},
      {'id': 'CONFIRMED', 'label': '☕ ${l10n.brewing}'},
      {'id': 'COMPLETED', 'label': '✅ ${l10n.completed}'},
    ];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(ordersProvider.notifier).loadOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersProvider);
    final filteredOrders = ordersState.filteredOrders;
    final totalOrdersCount = ordersState.totalVisibleCount;
    final isLoading = ordersState.isLoading;
    final selectedStatusFilter = ordersState.selectedFilter;

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Screen Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xxl,
                AppSpacing.lg,
                AppSpacing.xxl,
                AppSpacing.md + 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.yourOrders,
                        style: context.textTheme.headlineLarge,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        context.l10n.trackReceipts,
                        style: TextStyle(
                          fontSize: 14,
                          color: context.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs + 2,
                    ),
                    decoration: BoxDecoration(
                      color: context.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppRadii.lg),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.receipt_long_rounded,
                          size: 16,
                          color: context.colorScheme.primary,
                        ),
                        const SizedBox(width: AppSpacing.xs + 2),
                        Text(
                          SessionService.instance.isLoggedIn
                              ? context.l10n.ordersCount(totalOrdersCount)
                              : 'Guest',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Horizontal Status Filter Chips
            SizedBox(
              height: 38,
              child: Builder(
                builder: (context) {
                  final statusFilters = _getStatusFilters(context);
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                    itemCount: statusFilters.length,
                    separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final filter = statusFilters[index];
                      final isSelected = filter['id'] == selectedStatusFilter;
                      return ChoiceChip(
                        label: Text(
                          filter['label']!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: isSelected
                                ? context.colorScheme.onPrimary
                                : context.colorScheme.onSurface,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: context.colorScheme.primary,
                        backgroundColor: context.colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadii.pill),
                          side: BorderSide(
                            color: isSelected
                                ? context.colorScheme.primary
                                : context.colorScheme.outline,
                            width: 1.2,
                          ),
                        ),
                        showCheckmark: false,
                        onSelected: (_) {
                          ref
                              .read(ordersProvider.notifier)
                              .setFilter(filter['id']!);
                        },
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            // Orders List or Skeleton
            Expanded(
              child: RefreshIndicator(
                color: context.colorScheme.primary,
                backgroundColor: context.colorScheme.surface,
                onRefresh: () => ref.read(ordersProvider.notifier).refresh(),
                child: isLoading
                    ? _buildLoadingList()
                    : !SessionService.instance.isLoggedIn
                    ? _buildGuestState()
                    : filteredOrders.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                        itemCount: filteredOrders.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];
                          return _buildOrderCard(order);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingList() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: context.colorScheme.surfaceContainerHighest,
            highlightColor: context.colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: 140,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final dateFormat = DateFormat('MMM dd, hh:mm a');
    final formattedDate = dateFormat.format(order.createdAt);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md + 6),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadii.xxl),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Order ID + Status Badge + More Options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.shortId,
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  color: context.colorScheme.onSurface,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: order.getStatusBgColor(context),
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                    ),
                    child: Text(
                      order.statusLabel,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: order.getStatusTextColor(context),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert_rounded,
                      size: 18,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Options',
                    onSelected: (val) {
                      if (val == 'hide') {
                        _confirmHideOrder(order);
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'hide',
                        child: Row(
                          children: [
                            Icon(Icons.visibility_off_outlined, size: 18),
                            SizedBox(width: 8),
                            Text('Hide from history'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 6),
          Text(
            formattedDate,
            style: TextStyle(
              fontSize: 13,
              color: context.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Divider(
              color: context.colorScheme.outlineVariant,
              height: 1,
            ),
          ),

          // Items summary
          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item.quantity}x ${item.productName}',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: context.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '\$${item.totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Footer: Total Amount + Re-order Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.total,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    order.formattedTotal,
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      content: Text(
                        'Items from ${order.shortId} added to cart!',
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.refresh_rounded,
                  size: 16,
                  color: context.colorScheme.primary,
                ),
                label: Text(
                  context.l10n.reorder,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: context.colorScheme.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: context.colorScheme.primary, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGuestState() {
    return LayoutBuilder(
      builder: (_, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: context.colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      size: 38,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    context.l10n.loginToViewOrders,
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    context.l10n.loginPromptSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: context.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ClerkWebViewScreen(),
                          ),
                        );
                        if (result != null) {
                          String token = '';
                          String? email;
                          String? fullName;
                          String? avatarUrl;

                          if (result is ClerkAuthResult) {
                            token = result.token;
                            email = result.email;
                            fullName = result.fullName;
                            avatarUrl = result.avatarUrl;
                          } else if (result is String) {
                            token = result;
                          }

                          if (token.isNotEmpty) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: context.colorScheme.onPrimary,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(context.l10n.syncingWithBackend),
                                    ],
                                  ),
                                  backgroundColor: context.colorScheme.primary,
                                  duration: const Duration(seconds: 10),
                                ),
                              );
                            }

                            final success = await SessionService.instance
                                .loginWithClerkToken(
                                  token,
                                  email: email,
                                  fullName: fullName,
                                  avatarUrl: avatarUrl,
                                );

                            if (!mounted) return;
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();

                            if (success) {
                              ref.read(ordersProvider.notifier).loadOrders();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  content: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          context.l10n.signedInSuccessfully,
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: AppPalette.emeraldGreen,
                                ),
                              );
                            } else {
                              final errorMsg =
                                  SessionService.instance.lastAuthError ??
                                  context.l10n.syncFailed;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  content: Row(
                                    children: [
                                      const Icon(
                                        Icons.error_outline_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(child: Text(errorMsg)),
                                    ],
                                  ),
                                  backgroundColor: context.colorScheme.error,
                                ),
                              );
                            }
                          }
                        }
                      },
                      icon: const Icon(Icons.login_rounded, size: 18),
                      label: Text(
                        context.l10n.signInButton,
                        style: const TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: context.colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.coffee_outlined,
                      size: 36,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    context.l10n.noOrdersYet,
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.l10n.noOrdersSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: context.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmHideOrder(OrderModel order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hide Order'),
        content: Text(
          'Remove order ${order.shortId} from your order history view? You can still view receipts if needed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(ordersProvider.notifier).hideOrder(order.id);

              final messenger = ScaffoldMessenger.of(context);
              messenger.hideCurrentSnackBar();

              late final ScaffoldFeatureController<SnackBar, SnackBarClosedReason> controller;
              controller = messenger.showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  content: Text('Order ${order.shortId} hidden from your history.'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      ref.read(ordersProvider.notifier).unhideOrder(order.id);
                    },
                  ),
                  onVisible: () {
                    Future.delayed(const Duration(seconds: 2), () {
                      try {
                        controller.close();
                      } catch (_) {}
                    });
                  },
                ),
              );
            },
            child: const Text('Hide'),
          ),
        ],
      ),
    );
  }
}

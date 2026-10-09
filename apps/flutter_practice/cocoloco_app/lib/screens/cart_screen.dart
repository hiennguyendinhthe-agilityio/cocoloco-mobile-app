import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/localization/app_localizations.dart';
import '../core/providers/network_providers.dart';
import '../core/services/session_service.dart';
import '../core/theme/app_theme.dart';
import '../data/providers/cart_provider.dart';
import '../data/providers/orders_provider.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../data/providers/products_provider.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/guest_checkout_modal.dart';
import '../widgets/order_summary_card.dart';
import 'clerk_webview_screen.dart';
import 'order_success_screen.dart';
import 'product_detail_screen.dart';

class CartScreen extends ConsumerStatefulWidget {
  final List<CartItem>? initialItems;
  final VoidCallback? onCheckout;

  const CartScreen({super.key, this.initialItems, this.onCheckout});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
      }
    });
  }

  Future<void> _handleCheckout() async {
    final cartState = ref.read(cartProvider);
    if (cartState.isEmpty || cartState.isSubmitting) return;

    final session = SessionService.instance;
    if (!session.isLoggedIn) {
      final shouldSignIn = await GuestCheckoutModal.show(context);
      if (shouldSignIn != true || !mounted) return;

      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ClerkWebViewScreen()),
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

          final success = await SessionService.instance.loginWithClerkToken(
            token,
            email: email,
            fullName: fullName,
            avatarUrl: avatarUrl,
          );

          if (!mounted) return;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          if (success) {
            await _executeOrderPlacement();
          } else {
            final errorMsg = SessionService.instance.lastAuthError ??
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
      return;
    }

    await _executeOrderPlacement();
  }

  Future<void> _executeOrderPlacement() async {
    final orderRepo = ref.read(orderRepositoryProvider);
    final order = await ref.read(cartProvider.notifier).checkout(orderRepo);

    if (!mounted) return;

    if (order != null) {
      ref.read(ordersProvider.notifier).addOrder(order);
      widget.onCheckout?.call();
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(onDone: widget.onCheckout),
        ),
      );
    } else {
      final errorMsg =
          ref.read(cartProvider).errorMessage ?? context.l10n.orderFailed;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: context.colorScheme.error,
          action: SnackBarAction(
            label: context.l10n.retry,
            textColor: context.colorScheme.onError,
            onPressed: _handleCheckout,
          ),
        ),
      );
    }
  }

  void _openItemDetail(CartItem item) {
    Product? product = item.product;
    if (product == null) {
      final products = ref.read(productsProvider).products;
      product = products.where((p) => p.id == item.productId).firstOrNull;
    }
    product ??= Product(
      id: item.productId,
      name: item.name,
      description: item.customization,
      price: item.price,
      priceDisplay: '\$${item.price.toInt()}',
      imageAsset: 'assets/images/cappuccino.jpg',
      imageUrl: '',
      category: 'coffee',
      titleColor: item.titleColor,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(
          product: product!,
          isEditingFromCart: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xxl,
            topPadding + AppSpacing.md,
            AppSpacing.xxl,
            bottomInset > 0 ? bottomInset + AppSpacing.sm : AppSpacing.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                  onTap: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: context.colorScheme.primary,
                      size: 26,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Title: "My cart"
              Text(
                context.l10n.cartTitle,
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: context.colorScheme.primary,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Cart Items List or Empty State
              Expanded(
                child: cartState.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: 64,
                              color: context.colorScheme.outlineVariant,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              context.l10n.cartEmptyTitle,
                              style: TextStyle(
                                fontFamily: AppTypography.fontFamily,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: context.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              context.l10n.cartEmptySubtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: cartState.items.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.lg),
                        itemBuilder: (context, index) {
                          final item = cartState.items[index];
                          return Dismissible(
                            key: ValueKey(item.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.only(right: AppSpacing.xxl),
                              decoration: BoxDecoration(
                                color: context.colorScheme.error,
                                borderRadius:
                                    BorderRadius.circular(AppRadii.cardLg),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.delete_rounded,
                                    color: context.colorScheme.onError,
                                    size: 26,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    context.l10n.delete,
                                    style: TextStyle(
                                      color: context.colorScheme.onError,
                                      fontFamily: AppTypography.fontFamily,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onDismissed: (_) {
                              final removedItem = item;
                              final removedIndex = index;
                              ref
                                  .read(cartProvider.notifier)
                                  .removeItem(item.id);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${removedItem.name} removed from cart'),
                                  duration: const Duration(seconds: 4),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    textColor: AppPalette.honeyAmber,
                                    onPressed: () {
                                      ref
                                          .read(cartProvider.notifier)
                                          .restoreItem(removedItem,
                                              index: removedIndex);
                                    },
                                  ),
                                ),
                              );
                            },
                            child: CartItemCard(
                              item: item,
                              onTap: () => _openItemDetail(item),
                            ),
                          );
                        },
                      ),
              ),

              // Bottom Calculation Breakdown & Checkout Button
              if (!cartState.isEmpty) ...[
                OrderSummaryCard(
                  subtotal: cartState.subtotal,
                  deliveryFee: cartState.deliveryFee,
                  total: cartState.total,
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],

              // Primary "Go to checkout" Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: (cartState.isEmpty || cartState.isSubmitting)
                      ? null
                      : _handleCheckout,
                  child: cartState.isSubmitting
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: context.colorScheme.onPrimary,
                          ),
                        )
                      : Text(
                          context.l10n.checkout,
                          style: const TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

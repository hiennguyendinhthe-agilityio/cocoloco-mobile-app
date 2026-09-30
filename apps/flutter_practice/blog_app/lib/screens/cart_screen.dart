import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/network_providers.dart';
import '../core/services/session_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../data/providers/cart_provider.dart';
import '../data/providers/orders_provider.dart';
import '../models/cart_item.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/order_summary_card.dart';
import 'clerk_webview_screen.dart';
import 'order_success_screen.dart';

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
          final success = await SessionService.instance.loginWithClerkToken(
            token,
            email: email,
            fullName: fullName,
            avatarUrl: avatarUrl,
          );
          if (success && mounted) {
            await _executeOrderPlacement();
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
      final errorMsg = ref.read(cartProvider).errorMessage ??
          'Could not complete order. Please check your connection.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: const Color(0xFFC53030),
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: _handleCheckout,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            topPadding + 12,
            24,
            bottomInset > 0 ? bottomInset + 10 : 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.primary,
                      size: 26,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Title: "My cart"
              const Text(
                'My cart',
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 24),

              // Section Heading: "Summary"
              const Text(
                'Summary',
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  letterSpacing: -0.2,
                ),
              ),

              const SizedBox(height: 16),

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
                              color: AppColors.navInactive.withValues(alpha: 0.6),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Your cart is empty',
                              style: TextStyle(
                                fontFamily: AppTypography.fontFamily,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Explore Cocoloco\'s fresh coffee & bakery menu to get started!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: cartState.items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final item = cartState.items[index];
                          return CartItemCard(item: item);
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
                const SizedBox(height: 24),
              ],

              // Primary "Go to checkout" Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: (cartState.isEmpty || cartState.isSubmitting)
                      ? null
                      : _handleCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: cartState.isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Go to checkout',
                          style: TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
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

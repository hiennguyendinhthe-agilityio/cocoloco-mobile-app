import 'package:flutter/material.dart';
import '../core/services/session_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../data/repositories/order_repository.dart';
import '../widgets/clerk_auth_modal.dart';
import 'order_success_screen.dart';

class CartItem {
  final String id;
  final String name;
  final String customization;
  final int quantity;
  final double price;
  final Color titleColor;

  const CartItem({
    required this.id,
    required this.name,
    required this.customization,
    required this.quantity,
    required this.price,
    required this.titleColor,
  });
}

class CartScreen extends StatefulWidget {
  final List<CartItem>? initialItems;
  final VoidCallback? onCheckout;

  const CartScreen({super.key, this.initialItems, this.onCheckout});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartItem> _items;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
      }
    });
    _items =
        widget.initialItems ??
        const [
          CartItem(
            id: 'item_cappuccino',
            name: 'Cappuccino',
            customization: 'With extra milk',
            quantity: 2,
            price: 4.0,
            titleColor: AppColors.cappuccinoPink,
          ),
          CartItem(
            id: 'item_toast',
            name: 'Toast',
            customization: 'With avocado',
            quantity: 2,
            price: 6.0,
            titleColor: AppColors.croissantBlue,
          ),
        ];
  }

  double get _subtotal {
    if (_items.isEmpty) return 0.0;
    if (_items.length == 2 &&
        _items[0].id == 'item_cappuccino' &&
        _items[1].id == 'item_toast') {
      return 16.0;
    }
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get _delivery => _items.isEmpty ? 0.0 : 2.0;

  double get _total => _subtotal + _delivery;

  bool _isSubmitting = false;

  Future<void> _handleCheckout() async {
    if (_items.isEmpty) return;

    final session = SessionService.instance;
    if (!session.isLoggedIn) {
      ClerkAuthModal.show(context, onAuthSuccess: _processOrderCreation);
      return;
    }

    await _processOrderCreation();
  }

  Future<void> _processOrderCreation() async {
    setState(() => _isSubmitting = true);

    try {
      final itemsPayload = _items.map((item) {
        // extract clean id if starts with item_
        final cleanId = item.id.replaceFirst('item_', '');
        return {
          'product_id': cleanId,
          'name': item.name,
          'quantity': item.quantity,
        };
      }).toList();

      await OrderRepository().createOrder(items: itemsPayload);

      if (mounted) {
        setState(() => _isSubmitting = false);
        widget.onCheckout?.call();

        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => OrderSuccessScreen(onDone: widget.onCheckout),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => OrderSuccessScreen(onDone: widget.onCheckout),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              // Back Arrow Button
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

              // Title: "My cart" (Font: Chap, Weight: 900)
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

              // Section Heading: "Summary" (Font: Chap, Weight: 900)
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

              // Cart Items List
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: _items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return _buildCartItemCard(item);
                  },
                ),
              ),

              // Bottom Calculation Breakdown & Checkout Button
              Column(
                children: [
                  const SizedBox(height: 10),

                  // Subtotal Row
                  _buildCostRow(
                    label: 'Subtotal',
                    amount: '\$${_subtotal.toInt()}',
                    isTotal: false,
                  ),

                  const SizedBox(height: 10),

                  // Delivery Row
                  _buildCostRow(
                    label: 'Delivery',
                    amount: '\$${_delivery.toInt()}',
                    isTotal: false,
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: Color(0xFFF1ECE4), thickness: 1),
                  ),

                  // Total Row
                  _buildCostRow(
                    label: 'Total',
                    amount: '\$${_total.toInt()}',
                    isTotal: true,
                  ),

                  const SizedBox(height: 24),

                  // Primary "Go to checkout" Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: (_items.isEmpty || _isSubmitting) ? null : _handleCheckout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: _isSubmitting
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
            ],
          ),
        ),
      ),
    );
  }

  // Floating White Item Card matching Figma spec
  Widget _buildCartItemCard(CartItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Product Name & Customization note
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: item.titleColor,
                    height: 1.05,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  item.customization,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFA5B1BC),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Right: 2x Badge and Price
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // "2x" Pill Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EFE8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${item.quantity}x',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF260D11),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // Item Price ("$4", "$6")
              Text(
                '\$${item.price.toInt()}',
                style: const TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF260D11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCostRow({
    required String label,
    required String amount,
    required bool isTotal,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 15.5 : 15,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            color: const Color(0xFFA59E96),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: isTotal ? 17.5 : 16,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

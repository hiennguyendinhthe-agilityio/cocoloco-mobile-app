import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/special_offer.dart';

class PromoBannerCard extends StatelessWidget {
  final SpecialOffer offer;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;
  final Alignment imageAlignment;

  const PromoBannerCard({
    super.key,
    required this.offer,
    required this.onTap,
    required this.onAddToCart,
    this.imageAlignment = const Alignment(0, 0.45),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                offer.imageAsset,
                fit: BoxFit.cover,
                alignment: imageAlignment,
                errorBuilder: (_, _, _) => Container(
                  color: AppColors.primaryLight,
                  child: const Center(
                    child: Icon(
                      Icons.restaurant_menu_rounded,
                      color: Colors.white54,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),

            // Subtle dark overlay gradient for crisp typography
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.black.withValues(alpha: 0.15),
                      Colors.black.withValues(alpha: 0.45),
                    ],
                  ),
                ),
              ),
            ),

            // Banner Title ("BREAKFAST BUNDLE")
            Positioned(
              left: 24,
              bottom: 20,
              child: Text(
                offer.title,
                style: AppTypography.bannerTitle,
              ),
            ),

            // Floating Circular Shopping Cart Button
            Positioned(
              right: 20,
              bottom: 18,
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                elevation: 4,
                shadowColor: Colors.black45,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onAddToCart,
                  child: const SizedBox(
                    width: 50,
                    height: 50,
                    child: Center(
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: AppColors.cartButtonIcon,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Transparent Tap Area for the whole card
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: onTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

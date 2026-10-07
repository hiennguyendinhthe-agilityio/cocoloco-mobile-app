import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
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
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.cardHero),
        boxShadow: AppShadows.card,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.cardHero),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                offer.imageAsset,
                fit: BoxFit.cover,
                alignment: imageAlignment,
                errorBuilder: (_, _, _) => Container(
                  color: context.colorScheme.primaryContainer,
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
              left: AppSpacing.xl,
              bottom: AppSpacing.lg,
              child: Text(
                offer.title,
                style: AppTypography.bannerTitle,
              ),
            ),

            // Floating Circular Shopping Cart Button
            Positioned(
              right: AppSpacing.lg,
              bottom: 18,
              child: Material(
                color: context.colorScheme.surface,
                shape: const CircleBorder(),
                elevation: 4,
                shadowColor: Colors.black45,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onAddToCart,
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Center(
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: context.colorScheme.primary,
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
                  borderRadius: BorderRadius.circular(AppRadii.cardHero),
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

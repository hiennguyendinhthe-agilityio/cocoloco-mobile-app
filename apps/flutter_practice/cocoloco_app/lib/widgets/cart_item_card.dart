import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/cart_item.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback? onTap;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const CartItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.onIncrement,
    this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadii.cardLg),
        boxShadow: AppShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadii.cardLg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.cardLg),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.lg,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
          // Left: Product Name & Customization
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
                    color: item.titleColor == AppColors.primary
                        ? context.colorScheme.primary
                        : item.titleColor,
                    height: 1.05,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  item.customization,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Right: Quantity pill badge & Price
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Quantity pill badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                ),
                child: Text(
                  '${item.quantity}x',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: context.colorScheme.primary,
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              // Item Price
              Text(
                '\$${item.price.toInt()}',
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: context.colorScheme.primary,
                ),
              ),
              ],
            ),
          ],
        ),
      ),
    ),
  ),
);
  }
}

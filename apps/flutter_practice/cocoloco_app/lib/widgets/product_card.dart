import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/product.dart';
import 'package:shimmer/shimmer.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final Alignment imageAlignment;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.imageAlignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 182,
      margin: const EdgeInsets.only(right: AppSpacing.md, bottom: AppSpacing.xs),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadii.cardHero),
        boxShadow: AppShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadii.cardHero),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.cardHero),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Product Image container
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: SizedBox(
                  width: double.infinity,
                  height: 138,
                  child: Hero(
                    tag: 'hero_image_${product.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadii.cardInner),
                      child: _buildProductImage(context),
                    ),
                  ),
                ),
              ),

              // Name and Price
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTypography.productTitle(
                        product.titleColor == AppColors.primary
                            ? context.colorScheme.primary
                            : product.titleColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.priceDisplay,
                      style: AppTypography.productPrice.copyWith(
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    final url = product.imageUrl;
    final hasNetworkUrl = url != null &&
        url.isNotEmpty &&
        (url.startsWith('http://') || url.startsWith('https://'));

    if (hasNetworkUrl) {
      return CachedNetworkImage(
        imageUrl: url,
        width: double.infinity,
        height: 138,
        fit: BoxFit.cover,
        alignment: imageAlignment,
        placeholder: (_, __) => Shimmer.fromColors(
          baseColor: context.colorScheme.surfaceContainerHighest,
          highlightColor: context.colorScheme.surface,
          child: Container(
            color: context.colorScheme.surface,
          ),
        ),
        errorWidget: (_, __, ___) => _buildAssetFallback(context),
      );
    }

    return _buildAssetFallback(context);
  }

  Widget _buildAssetFallback(BuildContext context) {
    return Image.asset(
      product.imageAsset,
      width: double.infinity,
      height: 138,
      fit: BoxFit.cover,
      alignment: imageAlignment,
      errorBuilder: (_, __, ___) => Container(
        height: 138,
        color: context.colorScheme.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.local_cafe_rounded,
            size: 40,
            color: context.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}


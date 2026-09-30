import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
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
      margin: const EdgeInsets.only(right: 18, bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0E000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Product Image container with 10px outer margin and 22px corner radius
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: SizedBox(
                    width: double.infinity,
                    height: 138,
                    child: _buildProductImage(),
                  ),
                ),
              ),

              // Name and Price - Exact Figma layout: Left: 16px, Size: 20px, Height: 100%
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTypography.productTitle(product.titleColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.priceDisplay,
                      style: AppTypography.productPrice,
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

  Widget _buildProductImage() {
    final url = product.imageUrl;
    final hasNetworkUrl = url != null &&
        url.isNotEmpty &&
        (url.startsWith('http://') || url.startsWith('https://'));

    if (hasNetworkUrl) {
      return Hero(
        tag: 'hero_image_${product.id}',
        child: CachedNetworkImage(
          imageUrl: url,
          width: double.infinity,
          height: 138,
          fit: BoxFit.cover,
          alignment: imageAlignment,
          placeholder: (_, _) => Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[50]!,
            child: Container(
              color: Colors.white,
            ),
          ),
          errorWidget: (_, _, _) => _buildAssetFallback(),
        ),
      );
    }

    return _buildAssetFallback();
  }

  Widget _buildAssetFallback() {
    return Hero(
      tag: 'hero_image_${product.id}',
      child: Image.asset(
        product.imageAsset,
        width: double.infinity,
        height: 138,
        fit: BoxFit.cover,
        alignment: imageAlignment,
        errorBuilder: (_, _, _) => Container(
          height: 138,
          color: AppColors.surfaceMuted,
          child: const Center(
            child: Icon(
              Icons.local_cafe_rounded,
              size: 40,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}


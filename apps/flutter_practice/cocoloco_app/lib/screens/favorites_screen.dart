import 'package:flutter/material.dart';
import '../core/localization/app_localizations.dart';
import '../core/theme/app_theme.dart';

class FavoritesScreen extends StatelessWidget {
  final Function(String title, double price)? onAddToCart;

  const FavoritesScreen({super.key, this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.navFavorites,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: context.colorScheme.primary,
            fontSize: 24,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_rounded,
                size: 64,
                color: context.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.comingSoon,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: context.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.comingSoonMsg,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: context.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

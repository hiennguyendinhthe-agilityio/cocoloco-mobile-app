import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:blog_app/data/providers/products_provider.dart';
import 'package:blog_app/screens/browse_screen.dart';
import 'package:blog_app/widgets/product_card.dart';
import 'package:blog_app/widgets/promo_banner_card.dart';

void main() {
  Widget createBrowseScreen({void Function(String, double)? onAddToCart}) {
    return ProviderScope(
      child: MaterialApp(
        home: BrowseScreen(onAddToCart: onAddToCart),
      ),
    );
  }

  group('BrowseScreen Sliver & Interaction Tests', () {
    testWidgets('renders CustomScrollView, Slivers, and categories',
        (tester) async {
      await tester.pumpWidget(createBrowseScreen());
      await tester.pumpAndSettle();

      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.text("Let’s get this day going"), findsOneWidget);
      expect(find.text("April special"), findsOneWidget);

      // Verify category chips exist
      expect(find.text('All'), findsOneWidget);
      expect(find.text('☕ Coffee'), findsOneWidget);
      expect(find.text('🥐 Bakery'), findsOneWidget);
    });

    testWidgets('Selecting a category chip updates filter', (tester) async {
      await tester.pumpWidget(createBrowseScreen());
      await tester.pumpAndSettle();

      // Tap Coffee chip
      final coffeeChip = find.text('☕ Coffee');
      await tester.tap(coffeeChip);
      await tester.pumpAndSettle();

      // Tap same chip again (no-op check)
      await tester.tap(coffeeChip);
      await tester.pumpAndSettle();
    });

    testWidgets('Tapping search icon opens and closes search bar',
        (tester) async {
      await tester.pumpWidget(createBrowseScreen());
      await tester.pumpAndSettle();

      // Tap search icon in header (Icons.search_rounded)
      final searchButton = find.byIcon(Icons.search_rounded);
      expect(searchButton, findsOneWidget);
      await tester.tap(searchButton);
      await tester.pumpAndSettle();

      // Verify text field appears
      expect(find.byType(TextField), findsOneWidget);

      // Enter search text
      await tester.enterText(find.byType(TextField), 'Cappuccino');
      await tester.pumpAndSettle();

      // Clear search via clear icon
      final clearIcon = find.byIcon(Icons.clear);
      expect(clearIcon, findsOneWidget);
      await tester.tap(clearIcon);
      await tester.pumpAndSettle();

      // Tap search button again to close
      await tester.tap(searchButton);
      await tester.pumpAndSettle();
    });

    testWidgets('Tapping a product card opens ProductDetailScreen',
        (tester) async {
      await tester.pumpWidget(createBrowseScreen());
      await tester.pumpAndSettle();

      final firstProduct = find.byType(ProductCard).first;
      await tester.tap(firstProduct);
      await tester.pumpAndSettle();

      // Verify detail screen opened
      expect(find.text('View cart'), findsOneWidget);
    });

    testWidgets('Tapping promo banner card triggers onAddToCart and snackbar',
        (tester) async {
      String? addedItem;
      double? addedPrice;

      await tester.pumpWidget(
        createBrowseScreen(
          onAddToCart: (item, price) {
            addedItem = item;
            addedPrice = price;
          },
        ),
      );
      await tester.pumpAndSettle();

      // Find first promo banner
      final firstBanner = find.byType(PromoBannerCard).first;
      await tester.ensureVisible(firstBanner);
      await tester.pumpAndSettle();

      // Tap banner card
      await tester.tap(firstBanner);
      await tester.pump();

      expect(addedItem, isNotNull);
      expect(addedPrice, greaterThan(0));
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Empty product list renders empty state message',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            productsProvider.overrideWith(() => _EmptyProductsNotifier()),
          ],
          child: const MaterialApp(
            home: BrowseScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No items found in this category'), findsOneWidget);
    });
  });
}

class _EmptyProductsNotifier extends ProductsNotifier {
  @override
  ProductsState build() {
    return const ProductsState(products: [], isLoading: false);
  }
}

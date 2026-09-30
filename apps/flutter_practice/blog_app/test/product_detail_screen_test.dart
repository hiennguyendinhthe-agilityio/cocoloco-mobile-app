import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:blog_app/core/constants/mock_data.dart';
import 'package:blog_app/models/product.dart';
import 'package:blog_app/screens/product_detail_screen.dart';

void main() {
  final testProduct = MockData.dailyProducts.first; // Cappuccino

  Widget createTestWidget({
    Product? product,
    void Function(Product, int)? onAddToCart,
  }) {
    return ProviderScope(
      child: MaterialApp(
        home: ProductDetailScreen(
          product: product ?? testProduct,
          onAddToCart: onAddToCart ?? (product, quantity) {},
        ),
      ),
    );
  }

  group('ProductDetailScreen Sliver Layout Tests', () {
    testWidgets('renders CustomScrollView, SliverAppBar, and SliverToBoxAdapter',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Verify Slivers are present in the hierarchy
      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.byType(SliverAppBar), findsOneWidget);
      expect(find.byType(SliverToBoxAdapter), findsOneWidget);
      expect(find.byType(FlexibleSpaceBar), findsOneWidget);

      // Verify product information is rendered
      expect(find.text(testProduct.name), findsWidgets);
      expect(find.text(testProduct.description), findsOneWidget);
      expect(find.text('View cart'), findsOneWidget);
    });

    testWidgets('Stepper increments and decrements quantity correctly',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Initial state is 2x
      expect(find.text('2x'), findsOneWidget);
      expect(find.text('${(testProduct.price * 2).toInt()}\$'), findsOneWidget);

      // Tap + button
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pump();

      expect(find.text('3x'), findsOneWidget);
      expect(find.text('${(testProduct.price * 3).toInt()}\$'), findsOneWidget);

      // Tap - button twice
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(find.text('2x'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(find.text('1x'), findsOneWidget);

      // Cannot decrement below 1
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(find.text('1x'), findsOneWidget);
    });

    testWidgets('Toggling add-on cards works smoothly', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Find Extra milk card and ensure it's visible in viewport
      final milkCard = find.text('Extra milk');
      expect(milkCard, findsOneWidget);
      await tester.ensureVisible(milkCard);
      await tester.pumpAndSettle();

      // Tap to select
      await tester.tap(milkCard);
      await tester.pump();

      // Tap again to deselect
      await tester.tap(milkCard);
      await tester.pump();
    });

    testWidgets('Scrolling down collapses SliverAppBar without error',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Drag the CustomScrollView up by 300px
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Ensure view is still healthy and renders properly
      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.text('View cart'), findsOneWidget);
    });

    testWidgets('Tapping View Cart invokes onAddToCart callback',
        (tester) async {
      Product? addedProduct;
      int? addedQuantity;

      await tester.pumpWidget(
        createTestWidget(
          onAddToCart: (p, q) {
            addedProduct = p;
            addedQuantity = q;
          },
        ),
      );

      // Tap View cart button
      await tester.tap(find.text('View cart'));
      await tester.pump();

      expect(addedProduct?.id, equals(testProduct.id));
      expect(addedQuantity, equals(2));
    });
  });
}

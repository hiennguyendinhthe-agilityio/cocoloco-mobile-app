import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cocoloco_app/core/constants/mock_data.dart';
import 'package:cocoloco_app/core/localization/app_localizations.dart';
import 'package:cocoloco_app/data/providers/cart_provider.dart';
import 'package:cocoloco_app/models/product.dart';
import 'package:cocoloco_app/screens/cart_screen.dart';
import 'package:cocoloco_app/screens/product_detail_screen.dart';

void main() {
  final testProduct = MockData.dailyProducts.first; // Cappuccino

  Widget createTestWidget({
    Product? product,
    void Function(Product, int)? onAddToCart,
    bool isEditingFromCart = false,
    ProviderContainer? container,
  }) {
    final app = MaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: ProductDetailScreen(
        product: product ?? testProduct,
        onAddToCart: onAddToCart ?? (product, quantity) {},
        isEditingFromCart: isEditingFromCart,
      ),
    );

    if (container != null) {
      return UncontrolledProviderScope(
        container: container,
        child: app,
      );
    }
    return ProviderScope(child: app);
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

    testWidgets('Selecting add-ons updates price, bottom summary, and customization in cart',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Initial state: 2x Cappuccino, 6$
      expect(find.text('6\$'), findsOneWidget);
      expect(find.text('2x Cappuccino'), findsOneWidget);

      // Scroll down to make Add-on cards fully visible in test viewport (800x600)
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -200));
      await tester.pumpAndSettle();

      // Tap Extra milk (+$0.50)
      final extraMilk = find.text('Extra milk');
      await tester.tap(extraMilk);
      await tester.pumpAndSettle();

      // Price should update to 7$ ((3 + 0.5) * 2 = 7)
      expect(find.text('7\$'), findsOneWidget);
      expect(find.text('2x Cappuccino • Extra milk'), findsOneWidget);

      // Also tap Iced (Free)
      final iced = find.text('Iced');
      await tester.ensureVisible(iced);
      await tester.tap(iced);
      await tester.pumpAndSettle();

      // Summary shows both
      expect(find.text('7\$'), findsOneWidget);
      expect(find.text('2x Cappuccino • Extra milk, Iced'), findsOneWidget);
    });

    testWidgets('Repeatedly tapping View Cart does not accumulate quantity',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: ProductDetailScreen(
              product: testProduct,
              onAddToCart: (_, __) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // First tap on View cart
      await tester.tap(find.text('View cart'));
      await tester.pumpAndSettle();

      // Check cart has 1 item with quantity 2
      expect(container.read(cartProvider).items.length, equals(1));
      expect(container.read(cartProvider).items.first.quantity, equals(2));

      // Pop back from CartScreen
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pop();
      await tester.pumpAndSettle();

      // Second tap on View cart
      await tester.tap(find.text('View cart'));
      await tester.pumpAndSettle();

      // Cart quantity must STILL be 2, NOT 4!
      expect(container.read(cartProvider).items.length, equals(1));
      expect(container.read(cartProvider).items.first.quantity, equals(2));
    });

    testWidgets('Bakery product adapts stepper icon to bakery and renders bakery add-ons',
        (tester) async {
      final bakeryProduct = MockData.dailyProducts.firstWhere((p) => p.name == 'Crossaint');

      await tester.pumpWidget(createTestWidget(product: bakeryProduct));
      await tester.pumpAndSettle();

      // Stepper icon should be bakery dining icon (loaf of bread), NOT coffee cup!
      expect(find.byIcon(Icons.bakery_dining_rounded), findsOneWidget);
      expect(find.byIcon(Icons.coffee_rounded), findsNothing);

      // Scroll down to see add-on cards
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -200));
      await tester.pumpAndSettle();

      // Verify bakery specific add-ons
      expect(find.text('French butter'), findsOneWidget);
      expect(find.text('Warm toasted'), findsOneWidget);
      expect(find.text('Berry jam'), findsOneWidget);
      expect(find.text('Melted cheese'), findsOneWidget);

      // Verify drink add-ons are NOT shown
      expect(find.text('Extra milk'), findsNothing);

      // Tap French butter (+$0.50)
      await tester.tap(find.text('French butter'));
      await tester.pumpAndSettle();

      // Price: (3.0 + 0.50) * 2 = 7$
      expect(find.text('7\$'), findsOneWidget);
      expect(find.text('2x Crossaint • French butter'), findsOneWidget);
    });

    testWidgets('Healthy bowl product adapts stepper icon to rice bowl and renders bowl add-ons',
        (tester) async {
      final fruitProduct = MockData.dailyProducts.firstWhere((p) => p.name == 'Fresh Fruits');

      await tester.pumpWidget(createTestWidget(product: fruitProduct));
      await tester.pumpAndSettle();

      // Stepper icon should be rice bowl icon
      expect(find.byIcon(Icons.rice_bowl_rounded), findsOneWidget);
      expect(find.byIcon(Icons.coffee_rounded), findsNothing);

      // Scroll down to see add-on cards
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -200));
      await tester.pumpAndSettle();

      // Verify healthy bowl add-ons
      expect(find.text('Greek yogurt'), findsOneWidget);
      expect(find.text('Wild honey'), findsOneWidget);
      expect(find.text('Chia seeds'), findsOneWidget);
      expect(find.text('Fresh mint'), findsOneWidget);
    });

    testWidgets('Fresh Pasta adapts stepper icon to restaurant meal and renders savory add-ons',
        (tester) async {
      const pastaProduct = Product(
        id: 'prod_pasta_test',
        name: 'Fresh Pasta',
        priceDisplay: r'$8',
        price: 8.0,
        titleColor: Colors.brown,
        imageAsset: 'assets/images/cappuccino.jpg',
        description: 'Handmade seasonal tagliatelle with fresh Genovese basil and aged parmesan.',
        category: 'Seasonal',
      );

      await tester.pumpWidget(createTestWidget(product: pastaProduct));
      await tester.pumpAndSettle();

      // Stepper icon must be restaurant plate/cutlery, NOT coffee cup!
      expect(find.byIcon(Icons.restaurant_rounded), findsOneWidget);
      expect(find.byIcon(Icons.coffee_rounded), findsNothing);

      // Scroll down to see add-on cards
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -200));
      await tester.pumpAndSettle();

      // Verify savory meal add-ons
      expect(find.text('Aged parmesan'), findsOneWidget);
      expect(find.text('Crispy bacon'), findsOneWidget);
      expect(find.text('Garlic toast'), findsOneWidget);
      expect(find.text('Chili flakes'), findsOneWidget);

      // Verify drink add-ons are NOT shown
      expect(find.text('Extra milk'), findsNothing);
      expect(find.text('Iced'), findsNothing);
    });

    test('Product.productType accurately categorizes various food and drink types', () {
      final coffee = MockData.dailyProducts.firstWhere((p) => p.name == 'Cappuccino');
      final croissant = MockData.dailyProducts.firstWhere((p) => p.name == 'Crossaint');
      final fruit = MockData.dailyProducts.firstWhere((p) => p.name == 'Fresh Fruits');
      const pasta = Product(
        id: 'test_pasta',
        name: 'Fresh Pasta',
        priceDisplay: r'$8',
        price: 8.0,
        titleColor: Colors.brown,
        imageAsset: 'assets/images/cappuccino.jpg',
        description: 'Handmade tagliatelle',
        category: 'Seasonal',
      );

      expect(coffee.productType, equals(ProductType.drink));
      expect(croissant.productType, equals(ProductType.bakery));
      expect(fruit.productType, equals(ProductType.bowl));
      expect(pasta.productType, equals(ProductType.meal));
    });

    testWidgets('In edit mode (isEditingFromCart), stepper can decrease to 0 and removes product', (tester) async {
      await tester.pumpWidget(createTestWidget(isEditingFromCart: true));
      await tester.pumpAndSettle();

      // Initial state is 2x
      expect(find.text('2x'), findsOneWidget);

      // Tap - button once -> 1x
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(find.text('1x'), findsOneWidget);

      // Now at 1x in edit mode, minus button turns into trash icon
      expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);

      // Tap trash button -> 0x
      await tester.tap(find.byIcon(Icons.delete_outline_rounded));
      await tester.pump();
      expect(find.text('0x'), findsOneWidget);
      expect(find.text(r'$0'), findsOneWidget);
      expect(find.text('Remove'), findsOneWidget);

      // Tap + button -> increments back to 1x
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('1x'), findsOneWidget);
      expect(find.text('Update Cart'), findsOneWidget);

      // Tap trash button again -> 0x
      await tester.tap(find.byIcon(Icons.delete_outline_rounded));
      await tester.pump();
      expect(find.text('0x'), findsOneWidget);
      expect(find.text('Remove'), findsOneWidget);

      // Tap Remove button
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
    });

    testWidgets(
        'When opened from Home (isEditingFromCart: false), tapping View Cart opens CartScreen and does not pop to home even if product was already in cart',
        (tester) async {
      final container = ProviderContainer();
      // Pre-add product to cart to simulate that the item is already existing in cart
      container.read(cartProvider.notifier).addProduct(testProduct, quantity: 2);

      await tester.pumpWidget(createTestWidget(
        container: container,
        isEditingFromCart: false,
      ));
      await tester.pumpAndSettle();

      // Button says "View cart"
      expect(find.text('View cart'), findsOneWidget);

      // Tap "View cart"
      await tester.tap(find.text('View cart'));
      await tester.pumpAndSettle();

      // Should have pushed CartScreen, NOT popped to home!
      expect(find.byType(CartScreen), findsOneWidget);

      container.dispose();
    });
  });
}


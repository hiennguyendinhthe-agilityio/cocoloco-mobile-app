import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:blog_app/core/localization/app_localizations.dart';
import 'package:blog_app/core/providers/network_providers.dart';
import 'package:blog_app/core/theme/app_colors.dart';
import 'package:blog_app/data/repositories/product_repository.dart';
import 'package:blog_app/models/paginated_response.dart';
import 'package:blog_app/models/product.dart';
import 'package:blog_app/screens/admin_products_screen.dart';

class MockAdminProductRepo extends ProductRepository {
  List<Product> products;
  String? deletedProductId;

  MockAdminProductRepo({required this.products});

  @override
  Future<PaginatedResponse<Product>> getProductsPaged({
    String? category,
    int page = 1,
    int size = 10,
  }) async {
    return PaginatedResponse<Product>(
      items: products,
      total: products.length,
      page: 1,
      size: 10,
      pages: 1,
    );
  }

  @override
  Future<List<Product>> getProducts({String? category, int page = 1, int size = 20}) async {
    return products;
  }

  @override
  Future<void> deleteProduct(String id) async {
    deletedProductId = id;
    products.removeWhere((p) => p.id == id);
  }
}

void main() {
  late MockAdminProductRepo mockRepo;

  final sampleProducts = [
    const Product(
      id: 'prod-admin-1',
      name: 'Americano Classico',
      price: 3.50,
      priceDisplay: '\$3.50',
      category: 'coffee',
      description: 'Bold espresso diluted with hot water',
      imageAsset: 'assets/images/latte_art_pour.jpg',
      titleColor: AppColors.primary,
      isAvailable: true,
    ),
    const Product(
      id: 'prod-admin-2',
      name: 'Chocolate Eclair',
      price: 4.25,
      priceDisplay: '\$4.25',
      category: 'pastry',
      description: 'Choux pastry filled with cream and chocolate topping',
      imageAsset: 'assets/images/latte_art_pour.jpg',
      titleColor: AppColors.primary,
      isAvailable: true,
    ),
  ];

  setUp(() {
    mockRepo = MockAdminProductRepo(products: List.of(sampleProducts));
  });

  Widget createAdminProductsWidget() {
    return ProviderScope(
      overrides: [
        productRepositoryProvider.overrideWithValue(mockRepo),
      ],
      child: MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                AdminProductsScreen.show(context);
              },
              child: const Text('Show Admin Screen'),
            ),
          ),
        ),
      ),
    );
  }

  group('AdminProductsScreen Widget Tests', () {
    testWidgets('renders products title, add button, category chips, and items', (tester) async {
      await tester.pumpWidget(createAdminProductsWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show Admin Screen'));
      await tester.pumpAndSettle();

      expect(find.text('Product Management'), findsOneWidget);
      expect(find.text('Add New Product'), findsOneWidget);
      expect(find.text('Americano Classico'), findsOneWidget);
      expect(find.text('Chocolate Eclair'), findsOneWidget);
    });

    testWidgets('filtering by category chip switches active filter', (tester) async {
      await tester.pumpWidget(createAdminProductsWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show Admin Screen'));
      await tester.pumpAndSettle();

      final bakeryChip = find.text('🥐 Bakery');
      expect(bakeryChip, findsOneWidget);
      await tester.tap(bakeryChip);
      await tester.pumpAndSettle();
    });

    testWidgets('searching in search bar filters product list', (tester) async {
      await tester.pumpWidget(createAdminProductsWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show Admin Screen'));
      await tester.pumpAndSettle();

      // Enter search query
      final searchInput = find.byType(TextField);
      expect(searchInput, findsOneWidget);
      await tester.enterText(searchInput, 'Americano');
      await tester.pumpAndSettle();

      expect(find.text('Americano Classico'), findsOneWidget);
    });

    testWidgets('tapping delete icon shows confirmation dialog and deleting removes item', (tester) async {
      await tester.pumpWidget(createAdminProductsWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show Admin Screen'));
      await tester.pumpAndSettle();

      // Find first delete icon button
      final deleteIcons = find.byIcon(Icons.delete_outline_rounded);
      expect(deleteIcons, findsWidgets);

      await tester.tap(deleteIcons.first);
      await tester.pumpAndSettle();

      // Confirm delete dialog appeared
      expect(find.text('Delete'), findsWidgets);

      // Tap confirm button
      final confirmDeleteBtn = find.widgetWithText(ElevatedButton, 'Delete');
      await tester.tap(confirmDeleteBtn);
      await tester.pumpAndSettle();

      expect(mockRepo.deletedProductId, 'prod-admin-1');
      expect(find.text('Deleted "Americano Classico" successfully!'), findsOneWidget);
    });
  });
}

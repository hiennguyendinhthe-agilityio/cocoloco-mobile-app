import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cocoloco_app/core/localization/app_localizations.dart';
import 'package:cocoloco_app/core/providers/network_providers.dart';
import 'package:cocoloco_app/core/theme/app_colors.dart';
import 'package:cocoloco_app/data/repositories/product_repository.dart';
import 'package:cocoloco_app/models/paginated_response.dart';
import 'package:cocoloco_app/models/product.dart';
import 'package:cocoloco_app/widgets/admin_product_form_modal.dart';

class MockProductRepoForModal extends ProductRepository {
  Map<String, dynamic>? lastCreatedPayload;
  Map<String, dynamic>? lastUpdatedPayload;
  String? lastUpdatedId;

  @override
  Future<PaginatedResponse<Product>> getProductsPaged({
    String? category,
    int page = 1,
    int size = 10,
  }) async {
    return const PaginatedResponse<Product>(
      items: [],
      total: 0,
      page: 1,
      size: 10,
      pages: 0,
    );
  }

  @override
  Future<Product> createProduct(Map<String, dynamic> payload) async {
    lastCreatedPayload = payload;
    return Product(
      id: 'mock-created-id',
      name: payload['name'] as String,
      price: double.tryParse(payload['price']?.toString() ?? '0.0') ?? 0.0,
      priceDisplay: '\$${payload['price']}',
      category: payload['category'] as String? ?? 'coffee',
      description: payload['description'] as String? ?? '',
      imageAsset: 'assets/images/latte_art_pour.jpg',
      titleColor: AppColors.primary,
      isAvailable: payload['is_available'] as bool? ?? true,
    );
  }

  @override
  Future<Product> updateProduct(String id, Map<String, dynamic> payload) async {
    lastUpdatedId = id;
    lastUpdatedPayload = payload;
    return Product(
      id: id,
      name: payload['name'] as String? ?? 'Updated',
      price: double.tryParse(payload['price']?.toString() ?? '5.0') ?? 5.0,
      priceDisplay: '\$${payload['price']}',
      category: payload['category'] as String? ?? 'coffee',
      description: payload['description'] as String? ?? '',
      imageAsset: 'assets/images/latte_art_pour.jpg',
      titleColor: AppColors.primary,
      isAvailable: payload['is_available'] as bool? ?? true,
    );
  }
}

void main() {
  late MockProductRepoForModal mockRepo;

  setUp(() {
    mockRepo = MockProductRepoForModal();
  });

  Widget createModalWidget({Product? product}) {
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
                AdminProductFormModal.show(context, product: product);
              },
              child: const Text('Open Modal'),
            ),
          ),
        ),
      ),
    );
  }

  group('AdminProductFormModal Widget Tests', () {
    testWidgets('Create Mode: validates required fields on empty submit', (tester) async {
      await tester.pumpWidget(createModalWidget());
      await tester.pumpAndSettle();

      // Open Modal
      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Add New Product'), findsOneWidget);
      expect(find.text('NEW ITEM'), findsOneWidget);

      // Scroll to submit button and tap
      final saveButton = find.text('Add to Menu');
      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Field validation errors should appear
      expect(find.text('Product name cannot be empty'), findsOneWidget);
      expect(find.text('Price required'), findsOneWidget);
    });

    testWidgets('Create Mode: enforces minimum length for product name', (tester) async {
      await tester.pumpWidget(createModalWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      // Enter 1-char name
      final nameField = find.byType(TextFormField).first;
      await tester.enterText(nameField, 'A');

      final saveButton = find.text('Add to Menu');
      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('Product name must be at least 2 characters'), findsOneWidget);
    });

    testWidgets('Create Mode: submits successfully when inputs are valid', (tester) async {
      await tester.pumpWidget(createModalWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      // Enter Name
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Signature Cold Foam');

      // Enter Price
      await tester.enterText(textFields.at(1), '5.75');

      // Scroll to submit button and tap
      final saveButton = find.text('Add to Menu');
      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Verify createProduct was called
      expect(mockRepo.lastCreatedPayload, isNotNull);
      expect(mockRepo.lastCreatedPayload!['name'], 'Signature Cold Foam');
      expect(mockRepo.lastCreatedPayload!['price'].toString(), '5.75');

      // Verify success snackbar appears
      expect(find.text('Added "Signature Cold Foam" successfully!'), findsOneWidget);
    });

    testWidgets('Edit Mode: pre-populates product data and submits updates', (tester) async {
      const existingProduct = Product(
        id: 'prod-edit-99',
        name: 'Caramel Macchiato',
        price: 4.80,
        priceDisplay: '\$4.80',
        category: 'coffee',
        description: 'Rich espresso with vanilla and caramel drizzle',
        imageAsset: 'assets/images/latte_art_pour.jpg',
        titleColor: AppColors.primary,
        isAvailable: true,
      );

      await tester.pumpWidget(createModalWidget(product: existingProduct));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Edit Product'), findsOneWidget);
      expect(find.text('EDIT MODE'), findsOneWidget);
      expect(find.text('Caramel Macchiato'), findsOneWidget);
      expect(find.text('4.80'), findsOneWidget);

      // Change name
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Caramel Macchiato V2');

      // Scroll and tap Save
      final saveButton = find.text('Save Changes');
      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Verify updateProduct was called
      expect(mockRepo.lastUpdatedId, 'prod-edit-99');
      expect(mockRepo.lastUpdatedPayload!['name'], 'Caramel Macchiato V2');
      expect(find.text('Updated "Caramel Macchiato V2" successfully!'), findsOneWidget);
    });

    testWidgets('Presets: opens preset library and selects a preset item', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createModalWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      // Tap Presets button
      final presetsBtn = find.text('Presets');
      await tester.ensureVisible(presetsBtn);
      await tester.pumpAndSettle();
      await tester.tap(presetsBtn);
      await tester.pumpAndSettle();

      // Check Preset Library bottom sheet
      expect(find.text('Cocoloco Preset Library'), findsOneWidget);
      expect(find.text('Tap any photo to instantly use it for this product item:'), findsOneWidget);

      // Tap a preset item
      final presetItemFinder = find.descendant(
        of: find.byType(GridView),
        matching: find.byType(InkWell),
      );
      expect(presetItemFinder, findsWidgets);
      await tester.tap(presetItemFinder.first);
      await tester.pumpAndSettle();

      // Preset bottom sheet is closed
      expect(find.text('Cocoloco Preset Library'), findsNothing);
    });

    testWidgets('Validates URL format if provided', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createModalWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Valid Coffee');
      await tester.enterText(textFields.at(1), '4.50');
      // Enter invalid URL into URL field (textFields.at(2))
      await tester.enterText(textFields.at(2), 'invalid-image-url');

      final saveButton = find.text('Add to Menu');
      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('URL must start with http:// or https://'), findsOneWidget);
    });

    testWidgets('Changes category and toggles availability switch', (tester) async {
      await tester.pumpWidget(createModalWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      // Fill valid name and price
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Croissant Almond');
      await tester.enterText(textFields.at(1), '3.80');

      // Toggle availability switch
      final switchFinder = find.byType(Switch);
      await tester.ensureVisible(switchFinder);
      await tester.pumpAndSettle();
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // Submit
      final saveButton = find.text('Add to Menu');
      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(mockRepo.lastCreatedPayload, isNotNull);
      expect(mockRepo.lastCreatedPayload!['name'], 'Croissant Almond');
      expect(mockRepo.lastCreatedPayload!['is_available'], isFalse);
    });
  });
}

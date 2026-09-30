import 'package:blog_app/core/providers/network_providers.dart';
import 'package:blog_app/core/theme/app_colors.dart';
import 'package:blog_app/data/providers/products_provider.dart';
import 'package:blog_app/data/repositories/product_repository.dart';
import 'package:blog_app/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class MockProductRepository extends ProductRepository {
  List<Product> productsToReturn;
  bool shouldThrow;

  MockProductRepository({
    this.productsToReturn = const [],
    this.shouldThrow = false,
  });

  @override
  Future<List<Product>> getProducts({String? category, int page = 1, int size = 20}) async {
    if (shouldThrow) throw Exception('API Error');
    if (category != null && category.isNotEmpty && category != 'all') {
      return productsToReturn
          .where((p) => p.category.toLowerCase() == category.toLowerCase())
          .toList();
    }
    return productsToReturn;
  }

  @override
  Future<Product> createProduct(Map<String, dynamic> payload) async {
    if (shouldThrow) throw Exception('Create Error');
    return Product(
      id: 'created_uuid',
      name: payload['name'] ?? 'New Item',
      priceDisplay: '\$${payload['price']}',
      price: double.tryParse(payload['price']?.toString() ?? '0') ?? 0,
      titleColor: AppColors.americanoOrange,
      imageAsset: 'assets/images/cappuccino.jpg',
      description: payload['description'] ?? '',
      category: payload['category'] ?? 'Coffee',
      isAvailable: payload['is_available'] ?? true,
    );
  }

  @override
  Future<Product> updateProduct(String id, Map<String, dynamic> payload) async {
    if (shouldThrow) throw Exception('Update Error');
    final existing = productsToReturn.firstWhere(
      (p) => p.id == id,
      orElse: () => Product(
        id: id,
        name: 'Default',
        priceDisplay: '\$0',
        price: 0,
        titleColor: AppColors.americanoOrange,
        imageAsset: 'assets/images/cappuccino.jpg',
        description: '',
        category: 'Coffee',
      ),
    );

    return existing.copyWith(
      name: payload['name'],
      price: payload['price'] != null ? double.tryParse(payload['price'].toString()) : null,
      isAvailable: payload['is_available'],
    );
  }

  @override
  Future<void> deleteProduct(String id) async {
    if (shouldThrow) throw Exception('Delete Error');
  }
}

void main() {
  const p1 = Product(
    id: 'p1',
    name: 'Espresso Romano',
    priceDisplay: '\$3',
    price: 3.0,
    titleColor: AppColors.americanoOrange,
    imageAsset: 'assets/images/cappuccino.jpg',
    description: 'Espresso with lemon slice',
    category: 'Coffee',
    isAvailable: true,
  );

  const p2 = Product(
    id: 'p2',
    name: 'Almond Croissant',
    priceDisplay: '\$4',
    price: 4.0,
    titleColor: AppColors.croissantBlue,
    imageAsset: 'assets/images/croissant.jpg',
    description: 'Flaky almond pastry',
    category: 'Pastry',
    isAvailable: false,
  );

  group('ProductsState Filtering & Search', () {
    test('filteredProducts returns all when category is all and search is empty', () {
      const state = ProductsState(products: [p1, p2], selectedCategory: 'all');
      expect(state.filteredProducts.length, 2);
    });

    test('filteredProducts filters correctly by category', () {
      const state = ProductsState(products: [p1, p2], selectedCategory: 'coffee');
      expect(state.filteredProducts.length, 1);
      expect(state.filteredProducts.first.name, 'Espresso Romano');
    });

    test('filteredProducts filters correctly by search query in name or description', () {
      const state = ProductsState(
        products: [p1, p2],
        selectedCategory: 'all',
        searchQuery: 'flaky',
      );
      expect(state.filteredProducts.length, 1);
      expect(state.filteredProducts.first.name, 'Almond Croissant');
    });
  });

  group('ProductsNotifier State Transitions', () {
    test('loadProducts populates products list successfully', () async {
      final mockRepo = MockProductRepository(productsToReturn: [p1, p2]);
      final container = ProviderContainer(
        overrides: [
          productRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(productsProvider.notifier).loadProducts();
      final state = container.read(productsProvider);

      expect(state.products.length, 2);
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, isNull);
    });

    test('loadProducts handles error gracefully and sets errorMessage', () async {
      final mockRepo = MockProductRepository(shouldThrow: true);
      final container = ProviderContainer(
        overrides: [
          productRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(productsProvider.notifier).loadProducts();
      final state = container.read(productsProvider);

      expect(state.products, isEmpty);
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, isNotNull);
    });

    test('addProduct prepends new item into state products list', () async {
      final mockRepo = MockProductRepository(productsToReturn: [p1]);
      final container = ProviderContainer(
        overrides: [
          productRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(productsProvider.notifier).loadProducts();
      expect(container.read(productsProvider).products.length, 1);

      await container.read(productsProvider.notifier).addProduct({
        'name': 'Cold Foam Cappuccino',
        'price': '4.50',
        'category': 'Coffee',
      });

      final state = container.read(productsProvider);
      expect(state.products.length, 2);
      expect(state.products.first.name, 'Cold Foam Cappuccino');
    });

    test('editProduct updates item in state products list', () async {
      final mockRepo = MockProductRepository(productsToReturn: [p1, p2]);
      final container = ProviderContainer(
        overrides: [
          productRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(productsProvider.notifier).loadProducts();

      await container.read(productsProvider.notifier).editProduct('p1', {
        'name': 'Espresso Romano Gold',
        'price': '3.50',
      });

      final state = container.read(productsProvider);
      final edited = state.products.firstWhere((p) => p.id == 'p1');
      expect(edited.name, 'Espresso Romano Gold');
      expect(edited.price, 3.50);
    });

    test('removeProduct deletes item from state products list', () async {
      final mockRepo = MockProductRepository(productsToReturn: [p1, p2]);
      final container = ProviderContainer(
        overrides: [
          productRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(productsProvider.notifier).loadProducts();
      expect(container.read(productsProvider).products.length, 2);

      await container.read(productsProvider.notifier).removeProduct('p2');
      final state = container.read(productsProvider);
      expect(state.products.length, 1);
      expect(state.products.any((p) => p.id == 'p2'), isFalse);
    });

    test('toggleAvailability flips isAvailable boolean in state', () async {
      final mockRepo = MockProductRepository(productsToReturn: [p1]);
      final container = ProviderContainer(
        overrides: [
          productRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(productsProvider.notifier).loadProducts();
      expect(container.read(productsProvider).products.first.isAvailable, isTrue);

      await container.read(productsProvider.notifier).toggleAvailability(p1);
      expect(container.read(productsProvider).products.first.isAvailable, isFalse);
    });

    test('setCategory and setSearchQuery update filters in state', () {
      final container = ProviderContainer(
        overrides: [
          productRepositoryProvider.overrideWithValue(MockProductRepository()),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(productsProvider.notifier);
      notifier.setCategory('pastry');
      expect(container.read(productsProvider).selectedCategory, 'pastry');

      notifier.setSearchQuery('croissant');
      expect(container.read(productsProvider).searchQuery, 'croissant');
    });
  });
}

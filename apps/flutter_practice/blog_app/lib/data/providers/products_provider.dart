import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/network_providers.dart';
import '../../models/product.dart';
import '../repositories/product_repository.dart';

@immutable
class ProductsState {
  final List<Product> products;
  final bool isLoading;
  final String? errorMessage;
  final String selectedCategory;
  final String searchQuery;

  const ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.errorMessage,
    this.selectedCategory = 'all',
    this.searchQuery = '',
  });

  List<Product> get filteredProducts {
    return products.where((p) {
      final matchesCategory = selectedCategory == 'all' ||
          p.category.toLowerCase() == selectedCategory.toLowerCase() ||
          (selectedCategory == 'pastry' && p.category.toLowerCase() == 'bakery') ||
          (selectedCategory == 'bakery' && p.category.toLowerCase() == 'pastry');
      final matchesSearch = searchQuery.isEmpty ||
          p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  ProductsState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ProductsNotifier extends Notifier<ProductsState> {
  @override
  ProductsState build() {
    Future.microtask(() => loadProducts());
    return const ProductsState(isLoading: true);
  }

  ProductRepository get _repo => ref.read(productRepositoryProvider);

  /// Fetch products from backend or local fallback
  Future<void> loadProducts({String? category}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final categoryParam = category ??
          (state.selectedCategory == 'all' ? null : state.selectedCategory);
      final list = await _repo.getProducts(category: categoryParam);
      state = state.copyWith(
        products: list,
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      debugPrint('❌ [ProductsNotifier] loadProducts error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Could not load products. Please try again.',
      );
    }
  }

  void setCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Admin: Create new product via API and update state
  Future<Product> addProduct(Map<String, dynamic> payload) async {
    final newProduct = await _repo.createProduct(payload);
    state = state.copyWith(
      products: [newProduct, ...state.products],
      clearError: true,
    );
    return newProduct;
  }

  /// Admin: Update product details via API and update state
  Future<Product> editProduct(String id, Map<String, dynamic> payload) async {
    final updated = await _repo.updateProduct(id, payload);
    final updatedList = state.products.map((p) => p.id == id ? updated : p).toList();
    state = state.copyWith(
      products: updatedList,
      clearError: true,
    );
    return updated;
  }

  /// Admin: Remove product via API and update state
  Future<void> removeProduct(String id) async {
    await _repo.deleteProduct(id);
    final updatedList = state.products.where((p) => p.id != id).toList();
    state = state.copyWith(
      products: updatedList,
      clearError: true,
    );
  }

  /// Admin: Quick toggle availability (is_available)
  Future<Product> toggleAvailability(Product product) async {
    final newStatus = !product.isAvailable;
    final updated = await _repo.updateProduct(product.id, {
      'is_available': newStatus,
    });
    final updatedList = state.products.map((p) => p.id == product.id ? updated : p).toList();
    state = state.copyWith(
      products: updatedList,
      clearError: true,
    );
    return updated;
  }

  Future<void> refresh() async {
    await loadProducts();
  }
}

final productsProvider = NotifierProvider<ProductsNotifier, ProductsState>(() {
  return ProductsNotifier();
});

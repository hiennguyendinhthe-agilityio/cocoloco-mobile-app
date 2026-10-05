import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/network_providers.dart';
import '../../models/product.dart';
import '../repositories/product_repository.dart';

@immutable
class ProductsState {
  final List<Product> products;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final int totalItems;
  final String? errorMessage;
  final String selectedCategory;
  final String searchQuery;

  const ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.totalItems = 0,
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
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    int? totalItems,
    String? errorMessage,
    bool clearError = false,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      totalItems: totalItems ?? this.totalItems,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ProductsNotifier extends Notifier<ProductsState> {
  static const int defaultPageSize = 10;

  @override
  ProductsState build() {
    Future.microtask(() => loadProducts());
    return const ProductsState(isLoading: true);
  }

  ProductRepository get _repo => ref.read(productRepositoryProvider);

  /// Fetch initial page (Page 1) of products from backend or local fallback
  Future<void> loadProducts({String? category}) async {
    state = state.copyWith(
      isLoading: true,
      isLoadingMore: false,
      clearError: true,
      currentPage: 1,
      hasMore: true,
    );
    try {
      final categoryParam = category ??
          (state.selectedCategory == 'all' ? null : state.selectedCategory);
      final paged = await _repo.getProductsPaged(
        category: categoryParam,
        page: 1,
        size: defaultPageSize,
      );
      if (!ref.mounted) return;
      state = state.copyWith(
        products: paged.items,
        totalItems: paged.total,
        currentPage: 1,
        hasMore: paged.hasMore,
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      if (!ref.mounted) return;
      debugPrint('❌ [ProductsNotifier] loadProducts error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Could not load products. Please try again.',
      );
    }
  }

  /// Loads the next page of products (Infinite Scroll) with anti-spam guards
  Future<void> loadMoreProducts() async {
    // 1. Guard against duplicate / spam calls when fast-scrolling or exhausted
    if (state.isLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }

    state = state.copyWith(isLoadingMore: true);
    try {
      final nextPage = state.currentPage + 1;
      final categoryParam =
          state.selectedCategory == 'all' ? null : state.selectedCategory;

      final paged = await _repo.getProductsPaged(
        category: categoryParam,
        page: nextPage,
        size: defaultPageSize,
      );
      if (!ref.mounted) return;

      // Append new unique items (avoid any duplicate id collisions)
      final existingIds = state.products.map((p) => p.id).toSet();
      final newItems =
          paged.items.where((p) => !existingIds.contains(p.id)).toList();

      state = state.copyWith(
        products: [...state.products, ...newItems],
        totalItems: paged.total,
        currentPage: nextPage,
        hasMore: paged.hasMore,
        isLoadingMore: false,
        clearError: true,
      );
    } catch (e) {
      if (!ref.mounted) return;
      debugPrint('❌ [ProductsNotifier] loadMoreProducts error: $e');
      state = state.copyWith(isLoadingMore: false);
    }
  }

  void setCategory(String category) {
    if (state.selectedCategory == category) return;
    state = state.copyWith(
      selectedCategory: category,
      currentPage: 1,
      hasMore: true,
    );
    loadProducts(category: category == 'all' ? null : category);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Admin: Create new product via API and update state
  Future<Product> addProduct(Map<String, dynamic> payload) async {
    final newProduct = await _repo.createProduct(payload);
    state = state.copyWith(
      products: [newProduct, ...state.products],
      totalItems: state.totalItems + 1,
      clearError: true,
    );
    return newProduct;
  }

  /// Admin: Update product details via API and update state
  Future<Product> editProduct(String id, Map<String, dynamic> payload) async {
    final updated = await _repo.updateProduct(id, payload);
    final updatedList =
        state.products.map((p) => p.id == id ? updated : p).toList();
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
      totalItems: state.totalItems > 0 ? state.totalItems - 1 : 0,
      clearError: true,
    );
  }

  /// Admin: Quick toggle availability (is_available)
  Future<Product> toggleAvailability(Product product) async {
    final newStatus = !product.isAvailable;
    final updated = await _repo.updateProduct(product.id, {
      'is_available': newStatus,
    });
    final updatedList =
        state.products.map((p) => p.id == product.id ? updated : p).toList();
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

final productsProvider =
    NotifierProvider<ProductsNotifier, ProductsState>(() {
  return ProductsNotifier();
});

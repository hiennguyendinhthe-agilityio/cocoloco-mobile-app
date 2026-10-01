import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../core/constants/mock_data.dart';
import '../core/localization/app_localizations.dart';
import '../core/providers/network_providers.dart';
import '../core/theme/app_theme.dart';
import '../data/providers/products_provider.dart';
import '../models/product.dart';
import '../widgets/admin_product_form_modal.dart';
import '../widgets/cocoloco_header.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner_card.dart';
import 'product_detail_screen.dart';

class BrowseScreen extends ConsumerStatefulWidget {
  final Function(String title, double price)? onAddToCart;

  const BrowseScreen({super.key, this.onAddToCart});

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen> {
  String _selectedCategory = 'all';

  bool _isSearchOpen = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, String>> _getCategories(BuildContext context) {
    final l10n = context.l10n;
    return [
      {'id': 'all', 'label': l10n.categoryAll},
      {'id': 'coffee', 'label': l10n.categoryCoffee},
      {'id': 'pastry', 'label': l10n.categoryBakery},
      {'id': 'bundle', 'label': l10n.categoryCombos},
      {'id': 'seasonal', 'label': l10n.categorySpecials},
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    final categoryParam = _selectedCategory == 'all'
        ? null
        : _selectedCategory;
    await ref.read(productsProvider.notifier).loadProducts(
      category: categoryParam,
    );
  }

  void _onCategorySelected(String categoryId) {
    if (_selectedCategory == categoryId) return;
    setState(() => _selectedCategory = categoryId);
    ref.read(productsProvider.notifier).setCategory(categoryId);
  }

  void _openProductDetail(Product product) {
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 380),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProductDetailScreen(
          product: product,
          onAddToCart: (p, qty) {
            widget.onAddToCart?.call(p.name, p.price * qty);
          },
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(
            opacity: curvedAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _showAddedSnackbar(String item) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                context.l10n.addedToOrder(item),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Alignment _getProductAlignment(String id) {
    switch (id) {
      case 'prod_cappuccino':
        return const Alignment(0, 0.4);
      case 'prod_crossaint':
        return const Alignment(0, 0.05);
      default:
        return Alignment.center;
    }
  }

  Alignment _getBannerAlignment(String id) {
    switch (id) {
      case 'offer_breakfast_bundle':
        return const Alignment(0, 0.45);
      case 'offer_fruit_market':
        return const Alignment(0, 0.2);
      default:
        return Alignment.center;
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);
    final products = productsState.products;
    final isLoading = productsState.isLoading;
    final isAdmin = ref.watch(isAdminProvider);

    final filteredProducts = products.where((p) {
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == 'all' ||
          p.category.toLowerCase() == _selectedCategory.toLowerCase() ||
          (_selectedCategory == 'pastry' && p.category.toLowerCase() == 'bakery') ||
          (_selectedCategory == 'bakery' && p.category.toLowerCase() == 'pastry');

      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              backgroundColor: context.colorScheme.primary,
              elevation: 4,
              icon: Icon(Icons.add_rounded, color: context.colorScheme.onPrimary),
              label: Text(
                'Add Item',
                style: TextStyle(color: context.colorScheme.onPrimary, fontWeight: FontWeight.w700),
              ),
              onPressed: () => AdminProductFormModal.show(context),
            )
          : null,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar with authentic COCO LOCO Logo & Search
            CocolocoHeader(
              onSearchTap: () {
                setState(() {
                  _isSearchOpen = !_isSearchOpen;
                  if (!_isSearchOpen) {
                    _searchQuery = '';
                    _searchController.clear();
                  }
                });
              },
            ),

            // Expandable Search Bar
            AnimatedCrossFade(
              firstChild: const SizedBox(height: 0),
              secondChild: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: context.l10n.searchPlaceholder,
                    hintStyle: TextStyle(
                      color: context.colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: context.colorScheme.primary,
                      size: 20,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: context.colorScheme.surfaceContainerHighest,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              crossFadeState: _isSearchOpen
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),

            // Scrollable Content wrapped in Pull-to-Refresh with Slivers
            Expanded(
              child: RefreshIndicator(
                color: context.colorScheme.primary,
                backgroundColor: context.colorScheme.surface,
                onRefresh: _fetchProducts,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    // Section 1 Heading: "Let’s get this day going"
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 6),
                        child: Text(
                          context.l10n.letsGetThisDayGoing,
                          style: context.textTheme.headlineMedium,
                        ),
                      ),
                    ),

                    // Sticky Category Filter Chips (Pinned at top on scroll)
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _StickyCategoryHeaderDelegate(
                        categories: _getCategories(context),
                        selectedCategory: _selectedCategory,
                        onCategorySelected: _onCategorySelected,
                      ),
                    ),

                    // Section 1 Body: Product Carousel & Section 2 Heading
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),

                          // Horizontal Product Carousel or Loading Skeleton
                          SizedBox(
                            height: 248,
                            child: isLoading
                                ? _buildLoadingCarousel()
                                : filteredProducts.isEmpty
                                ? _buildEmptyState()
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    itemCount: filteredProducts.length,
                                    itemBuilder: (context, index) {
                                      final product = filteredProducts[index];
                                      return ProductCard(
                                        product: product,
                                        imageAlignment: _getProductAlignment(
                                          product.id,
                                        ),
                                        onTap: () => _openProductDetail(product),
                                      );
                                    },
                                  ),
                          ),

                          const SizedBox(height: 24),

                          // Section 2 Heading
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
                            child: Text(
                              context.l10n.aprilSpecial,
                              style: context.textTheme.headlineMedium,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Section 2: Lazy SliverList of Promo Banners
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverList.builder(
                        itemCount: MockData.specialOffers.length,
                        itemBuilder: (context, index) {
                          final offer = MockData.specialOffers[index];
                          return PromoBannerCard(
                            offer: offer,
                            imageAlignment: _getBannerAlignment(offer.id),
                            onTap: () {
                              widget.onAddToCart?.call(
                                offer.subtitle,
                                offer.price,
                              );
                              _showAddedSnackbar(offer.subtitle);
                            },
                            onAddToCart: () {
                              widget.onAddToCart?.call(
                                offer.subtitle,
                                offer.price,
                              );
                              _showAddedSnackbar(offer.subtitle);
                            },
                          );
                        },
                      ),
                    ),

                    // Bottom Spacing
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCarousel() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          width: 182,
          margin: const EdgeInsets.only(right: 18, bottom: 8),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadii.hero),
            boxShadow: AppShadows.soft,
          ),
          child: Shimmer.fromColors(
            baseColor: context.colorScheme.surfaceContainerHighest,
            highlightColor: context.colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Container(
                    height: 138,
                    decoration: BoxDecoration(
                      color: context.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: 100,
                        decoration: BoxDecoration(
                          color: context.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 14,
                        width: 50,
                        decoration: BoxDecoration(
                          color: context.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48,
            color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            context.l10n.noProductsFound,
            style: TextStyle(
              color: context.colorScheme.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyCategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final List<Map<String, String>> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const _StickyCategoryHeaderDelegate({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  double get minExtent => 52.0;

  @override
  double get maxExtent => 52.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: 52.0,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: overlapsContent
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat['id'] == selectedCategory;
          return ChoiceChip(
            label: Text(
              cat['label']!,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected
                    ? context.colorScheme.onPrimary
                    : context.colorScheme.onSurface,
              ),
            ),
            selected: isSelected,
            selectedColor: context.colorScheme.primary,
            backgroundColor: context.colorScheme.surfaceContainerHighest,
            elevation: isSelected ? 2 : 0,
            pressElevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.pill),
              side: BorderSide(
                color: isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.outline,
                width: 1.2,
              ),
            ),
            showCheckmark: false,
            onSelected: (_) => onCategorySelected(cat['id']!),
          );
        },
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _StickyCategoryHeaderDelegate oldDelegate) {
    return oldDelegate.selectedCategory != selectedCategory ||
        oldDelegate.categories != categories;
  }
}


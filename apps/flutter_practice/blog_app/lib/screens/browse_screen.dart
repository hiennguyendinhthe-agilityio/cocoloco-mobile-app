import 'package:flutter/material.dart';
import '../core/constants/mock_data.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../data/repositories/product_repository.dart';
import '../models/product.dart';
import '../widgets/cocoloco_header.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner_card.dart';
import 'product_detail_screen.dart';

class BrowseScreen extends StatefulWidget {
  final Function(String title, double price)? onAddToCart;

  const BrowseScreen({
    super.key,
    this.onAddToCart,
  });

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final ProductRepository _productRepository = ProductRepository();

  List<Product> _products = [];
  bool _isLoading = true;
  String _selectedCategory = 'all';

  bool _isSearchOpen = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _categories = const [
    {'id': 'all', 'label': 'All'},
    {'id': 'coffee', 'label': '☕ Coffee'},
    {'id': 'pastry', 'label': '🥐 Bakery'},
    {'id': 'bundle', 'label': '🎁 Combos'},
    {'id': 'seasonal', 'label': '✨ Specials'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    try {
      final categoryParam = _selectedCategory == 'all' ? null : _selectedCategory;
      final products = await _productRepository.getProducts(category: categoryParam);
      if (mounted) {
        setState(() {
          _products = products;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _products = MockData.dailyProducts;
          _isLoading = false;
        });
      }
    }
  }

  void _onCategorySelected(String categoryId) {
    if (_selectedCategory == categoryId) return;
    setState(() => _selectedCategory = categoryId);
    _fetchProducts();
  }

  void _openProductDetail(Product product) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(
          product: product,
          onAddToCart: (p, qty) {
            widget.onAddToCart?.call(p.name, p.price * qty);
          },
        ),
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
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Added $item to order',
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
    final filteredProducts = _products.where((p) {
      if (_searchQuery.isEmpty) return true;
      return p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
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
                    hintText: 'Search coffee, bakery & specials...',
                    hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: AppColors.primary, size: 20),
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
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              crossFadeState:
                  _isSearchOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),

            // Scrollable Content wrapped in Pull-to-Refresh
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                backgroundColor: Colors.white,
                onRefresh: _fetchProducts,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section 1: "Let's get this day going"
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                        child: Text(
                          "Let’s get this day going",
                          style: AppTypography.sectionHeading,
                        ),
                      ),

                      // Category Filter Chips
                      SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: _categories.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final cat = _categories[index];
                            final isSelected = cat['id'] == _selectedCategory;
                            return ChoiceChip(
                              label: Text(
                                cat['label']!,
                                style: TextStyle(
                                  fontFamily: AppTypography.fontFamily,
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                  color: isSelected ? Colors.white : AppColors.textDark,
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: AppColors.primary,
                              backgroundColor: Colors.white,
                              elevation: isSelected ? 2 : 0,
                              pressElevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primary
                                      : const Color(0xFFECE7DE),
                                  width: 1.2,
                                ),
                              ),
                              showCheckmark: false,
                              onSelected: (_) => _onCategorySelected(cat['id']!),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Horizontal Product Carousel or Loading Skeleton
                      SizedBox(
                        height: 248,
                        child: _isLoading
                            ? _buildLoadingCarousel()
                            : filteredProducts.isEmpty
                                ? _buildEmptyState()
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(horizontal: 24),
                                    itemCount: filteredProducts.length,
                                    itemBuilder: (context, index) {
                                      final product = filteredProducts[index];
                                      return ProductCard(
                                        product: product,
                                        imageAlignment: _getProductAlignment(product.id),
                                        onTap: () => _openProductDetail(product),
                                      );
                                    },
                                  ),
                      ),

                      const SizedBox(height: 24),

                      // Section 2: "April special"
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
                        child: Text(
                          "April special",
                          style: AppTypography.sectionHeading,
                        ),
                      ),

                      // Vertical Banner List
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: MockData.specialOffers.map((offer) {
                            return PromoBannerCard(
                              offer: offer,
                              imageAlignment: _getBannerAlignment(offer.id),
                              onTap: () {
                                widget.onAddToCart?.call(offer.subtitle, offer.price);
                                _showAddedSnackbar(offer.subtitle);
                              },
                              onAddToCart: () {
                                widget.onAddToCart?.call(offer.subtitle, offer.price);
                                _showAddedSnackbar(offer.subtitle);
                              },
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Container(
                  height: 138,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
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
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 14,
                      width: 50,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
          Icon(Icons.inventory_2_outlined, size: 48, color: AppColors.textSecondary.withValues(alpha: 0.5)),
          const SizedBox(height: 8),
          const Text(
            'No items found in this category',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/localization/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../data/providers/cart_provider.dart';
import '../models/product.dart';
import 'cart_screen.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;
  final Function(Product product, int quantity)? onAddToCart;
  final bool isEditingFromCart;

  const ProductDetailScreen({
    super.key,
    required this.product,
    this.onAddToCart,
    this.isEditingFromCart = false,
  });

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _quantity = 2; // Matching Figma demo state (2x)
  final Set<String> _selectedAddons = {};
  late final ScrollController _scrollController;
  bool _isCollapsed = false;
  bool _hasInitialSyncDone = false;

  // Contextual Add-on Configs
  static final List<_AddonConfig> _drinkAddons = [
    _AddonConfig(
      id: 'extra_milk',
      title: 'Extra milk',
      price: 0.5,
      priceDisplay: r'+$0.50',
      iconBuilder: (color) => _MilkCartonIcon(color: color),
    ),
    _AddonConfig(
      id: 'iced',
      title: 'Iced',
      price: 0.0,
      priceDisplay: 'Free',
      iconBuilder: (color) => _IceCubesIcon(color: color),
    ),
    _AddonConfig(
      id: 'light_foam',
      title: 'Light foam',
      price: 0.0,
      priceDisplay: 'Free',
      iconBuilder: (color) => _LightFoamIcon(color: color),
    ),
    _AddonConfig(
      id: 'caramel_drizzle',
      title: 'Caramel',
      price: 0.5,
      priceDisplay: r'+$0.50',
      iconBuilder: (color) => _CaramelIcon(color: color),
    ),
  ];

  static final List<_AddonConfig> _bakeryAddons = [
    _AddonConfig(
      id: 'french_butter',
      title: 'French butter',
      price: 0.5,
      priceDisplay: r'+$0.50',
      iconBuilder: (color) => Icon(Icons.breakfast_dining_rounded, size: 28, color: color),
    ),
    _AddonConfig(
      id: 'warm_toasted',
      title: 'Warm toasted',
      price: 0.0,
      priceDisplay: 'Free',
      iconBuilder: (color) => Icon(Icons.whatshot_rounded, size: 28, color: color),
    ),
    _AddonConfig(
      id: 'berry_jam',
      title: 'Berry jam',
      price: 0.5,
      priceDisplay: r'+$0.50',
      iconBuilder: (color) => Icon(Icons.icecream_rounded, size: 28, color: color),
    ),
    _AddonConfig(
      id: 'melted_cheese',
      title: 'Melted cheese',
      price: 0.75,
      priceDisplay: r'+$0.75',
      iconBuilder: (color) => Icon(Icons.layers_rounded, size: 28, color: color),
    ),
  ];

  static final List<_AddonConfig> _bowlAddons = [
    _AddonConfig(
      id: 'greek_yogurt',
      title: 'Greek yogurt',
      price: 0.75,
      priceDisplay: r'+$0.75',
      iconBuilder: (color) => Icon(Icons.water_drop_rounded, size: 28, color: color),
    ),
    _AddonConfig(
      id: 'wild_honey',
      title: 'Wild honey',
      price: 0.5,
      priceDisplay: r'+$0.50',
      iconBuilder: (color) => Icon(Icons.eco_rounded, size: 28, color: color),
    ),
    _AddonConfig(
      id: 'chia_seeds',
      title: 'Chia seeds',
      price: 0.5,
      priceDisplay: r'+$0.50',
      iconBuilder: (color) => Icon(Icons.grain_rounded, size: 28, color: color),
    ),
    _AddonConfig(
      id: 'fresh_mint',
      title: 'Fresh mint',
      price: 0.0,
      priceDisplay: 'Free',
      iconBuilder: (color) => Icon(Icons.spa_rounded, size: 28, color: color),
    ),
  ];

  static final List<_AddonConfig> _mealAddons = [
    _AddonConfig(
      id: 'aged_parmesan',
      title: 'Aged parmesan',
      price: 0.75,
      priceDisplay: r'+$0.75',
      iconBuilder: (color) => Icon(Icons.layers_rounded, size: 28, color: color),
    ),
    _AddonConfig(
      id: 'crispy_bacon',
      title: 'Crispy bacon',
      price: 1.0,
      priceDisplay: r'+$1.00',
      iconBuilder: (color) => Icon(Icons.kebab_dining_rounded, size: 28, color: color),
    ),
    _AddonConfig(
      id: 'garlic_toast',
      title: 'Garlic toast',
      price: 0.75,
      priceDisplay: r'+$0.75',
      iconBuilder: (color) => Icon(Icons.breakfast_dining_rounded, size: 28, color: color),
    ),
    _AddonConfig(
      id: 'chili_flakes',
      title: 'Chili flakes',
      price: 0.0,
      priceDisplay: 'Free',
      iconBuilder: (color) => Icon(Icons.whatshot_rounded, size: 28, color: color),
    ),
  ];

  ProductType get _productType => widget.product.productType;

  List<_AddonConfig> get _currentAddons {
    switch (_productType) {
      case ProductType.drink:
        return _drinkAddons;
      case ProductType.bakery:
        return _bakeryAddons;
      case ProductType.bowl:
        return _bowlAddons;
      case ProductType.meal:
        return _mealAddons;
    }
  }

  _AddonConfig? _findAddon(String id) {
    for (final addon in _currentAddons) {
      if (addon.id == id) return addon;
    }
    for (final addon in [..._drinkAddons, ..._bakeryAddons, ..._bowlAddons, ..._mealAddons]) {
      if (addon.id == id) return addon;
    }
    return null;
  }

  static IconData _getStepperIcon(ProductType type) {
    switch (type) {
      case ProductType.drink:
        return Icons.coffee_rounded;
      case ProductType.bakery:
        return Icons.bakery_dining_rounded;
      case ProductType.bowl:
        return Icons.rice_bowl_rounded;
      case ProductType.meal:
        return Icons.restaurant_rounded;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final collapsed = _scrollController.offset > (340 - kToolbarHeight);
    if (collapsed != _isCollapsed) {
      setState(() => _isCollapsed = collapsed);
    }
  }

  void _syncWithCartOnce() {
    if (_hasInitialSyncDone) return;
    _hasInitialSyncDone = true;
    final cartItems = ref.read(cartProvider).items;
    final existing = cartItems.where((i) => i.productId == widget.product.id).firstOrNull;
    if (existing != null) {
      _quantity = existing.quantity;
      if (existing.customization.isNotEmpty && existing.customization != 'Standard') {
        final lower = existing.customization.toLowerCase();
        for (final addon in _currentAddons) {
          if (lower.contains(addon.title.toLowerCase()) ||
              lower.contains(addon.id.replaceAll('_', ' '))) {
            _selectedAddons.add(addon.id);
          }
        }
      }
    }
  }

  double get _addonsTotalPerItem {
    double total = 0.0;
    for (final id in _selectedAddons) {
      final info = _findAddon(id);
      if (info != null) total += info.price;
    }
    return total;
  }

  double get _unitPrice => widget.product.price + _addonsTotalPerItem;
  double get _totalPrice => _unitPrice * _quantity;

  String get _addonsCustomizationString {
    final names = _selectedAddons.map((id) => _findAddon(id)?.title ?? id).toList();
    return names.isNotEmpty ? names.join(', ') : 'Standard';
  }

  String get _addonsSummary {
    final names = _selectedAddons.map((id) => _findAddon(id)?.title ?? id).toList();
    return names.join(', ');
  }

  Widget _buildHeroImage() {
    final url = widget.product.imageUrl;
    final hasNetworkUrl = url != null &&
        url.isNotEmpty &&
        (url.startsWith('http://') || url.startsWith('https://'));

    Widget rawImage;
    if (hasNetworkUrl) {
      rawImage = CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        alignment: const Alignment(0, 0.2),
        placeholder: (_, __) => Shimmer.fromColors(
          baseColor: context.colorScheme.surfaceContainerHighest,
          highlightColor: context.colorScheme.surface,
          child: Container(
            color: context.colorScheme.surface,
          ),
        ),
        errorWidget: (_, __, ___) => Image.asset(
          widget.product.imageAsset,
          fit: BoxFit.cover,
          alignment: const Alignment(0, 0.2),
        ),
      );
    } else {
      rawImage = Image.asset(
        widget.product.imageAsset,
        fit: BoxFit.cover,
        alignment: const Alignment(0, 0.2),
      );
    }

    return Hero(
      tag: 'hero_image_${widget.product.id}',
      flightShuttleBuilder: (
        flightContext,
        animation,
        flightDirection,
        fromHeroContext,
        toHeroContext,
      ) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            // animation.value: 0.0 at ProductCard <-> 1.0 at ProductDetailScreen
            final t = Curves.fastOutSlowIn.transform(animation.value);

            // Interpolate corner radii: 20px (card) <-> 0px (detail screen top)
            final cardBorderRadius = BorderRadius.lerp(
              BorderRadius.circular(AppRadii.cardInner),
              BorderRadius.zero,
              t,
            )!;

            // Dynamically scale the bottom sheet curve:
            // At card (t <= 0.25): height = 0 (perfect unblemished card image, no cutout!)
            // At detail (t = 1.0): height = 32px (full rounded sheet cap overlapping photo)
            final curveProgress = ((t - 0.25) / 0.75).clamp(0.0, 1.0);
            final curveHeight = 32.0 * curveProgress;
            final curveRadius = 32.0 * curveProgress;

            return Material(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: cardBorderRadius,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    rawImage,
                    if (curveHeight > 0.5)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: -1,
                        height: curveHeight,
                        child: Opacity(
                          opacity: curveProgress,
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.colorScheme.surface,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(curveRadius),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          rawImage,
          // Seamless rounded sheet top cap - part of the Hero so it flies with the image and never snaps in late!
          Positioned(
            left: 0,
            right: 0,
            bottom: -1,
            height: 32,
            child: Container(
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _syncWithCartOnce();
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Scrollable Content with Slivers
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              // Expandable & Collapsing Hero Image AppBar
              SliverAppBar(
                expandedHeight: 340.0,
                pinned: true,
                stretch: true,
                elevation: _isCollapsed ? 1.0 : 0.0,
                shadowColor: Colors.black12,
                backgroundColor: context.colorScheme.surface,
                surfaceTintColor: Colors.transparent,
                leading: Center(
                  child: Container(
                    margin: const EdgeInsets.only(left: 14),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _isCollapsed
                          ? context.colorScheme.surfaceContainerHighest
                          : Colors.black.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color:
                              _isCollapsed ? context.colorScheme.onSurface : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isCollapsed ? 1.0 : 0.0,
                  child: Text(
                    widget.product.name,
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                ),
                centerTitle: true,
                actions: [
                  Consumer(
                    builder: (context, ref, _) {
                      final cartItemCount = ref.watch(cartProvider.select((s) => s.totalItemCount));
                      return Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: _isCollapsed
                                    ? context.colorScheme.surfaceContainerHighest
                                    : Colors.black.withValues(alpha: 0.35),
                                shape: BoxShape.circle,
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(AppRadii.pill),
                                  onTap: () {
                                    if (widget.isEditingFromCart && Navigator.of(context).canPop()) {
                                      Navigator.of(context).pop();
                                    } else {
                                      Navigator.of(context, rootNavigator: true).push(
                                        MaterialPageRoute(builder: (_) => const CartScreen()),
                                      );
                                    }
                                  },
                                  child: Icon(
                                    Icons.shopping_bag_outlined,
                                    color: _isCollapsed ? context.colorScheme.onSurface : Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            if (cartItemCount > 0)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE65100),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                  child: Text(
                                    '$cartItemCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      height: 1.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                  ],
                  background: _buildHeroImage(),
                ),
              ),

              // Product Details Body inside SliverToBoxAdapter
              SliverToBoxAdapter(
                child: Container(
                  color: context.colorScheme.surface,
                  padding: EdgeInsets.fromLTRB(
                    24,
                    4,
                    24,
                    bottomInset > 0 ? bottomInset + 110 : 120,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        // Title, Price & Quantity Stepper Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left: Title & Unit Price
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.product.name,
                                    style: TextStyle(
                                      fontFamily: AppTypography.fontFamily,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                      height: 1.0,
                                      color: widget.product.titleColor,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.product.priceDisplay,
                                    style: TextStyle(
                                      fontFamily: AppTypography.fontFamily,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: context.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Right: Custom Cocoloco Stepper ([-] 2x/Cup [+])
                            _buildFigmaStepper(),
                          ],
                        ),

                        const SizedBox(height: 22),

                        // Description Paragraph
                        Text(
                          widget.product.description,
                          style: TextStyle(
                            fontSize: 14.5,
                            height: 1.48,
                            color: context.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Customization / Add-on Cards Row (Horizontal Scroll)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          clipBehavior: Clip.none,
                          child: Row(
                            children: [
                              for (int i = 0; i < _currentAddons.length; i++) ...[
                                if (i > 0) const SizedBox(width: 14),
                                _buildAddonCard(addon: _currentAddons[i]),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          // Bottom Bar (Seamlessly integrated, exactly aligned with body 24px margins)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: context.colorScheme.outlineVariant.withValues(alpha: 0.5),
                    width: 1.0,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(
                24,
                14,
                24,
                bottomInset > 0 ? bottomInset + 10 : 24,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left: Price & Quantity Label - exactly aligned with left margin (24px)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _quantity == 0
                              ? r'$0'
                              : '${_totalPrice.toStringAsFixed(_totalPrice.truncateToDouble() == _totalPrice ? 0 : 2)}\$',
                          style: TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: _quantity == 0
                                ? context.colorScheme.error
                                : context.colorScheme.onSurface,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _quantity == 0
                              ? 'Item will be removed from cart'
                              : '${_quantity}x ${widget.product.name}${_addonsSummary.isNotEmpty ? " • $_addonsSummary" : ""}',
                          style: TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: _quantity == 0
                                ? context.colorScheme.error
                                : context.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Right: "View cart" / "Update Cart" / "Remove" Button
                  SizedBox(
                    width: 176,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).clearSnackBars();

                        if (_quantity == 0) {
                          ref.read(cartProvider.notifier).removeItem(widget.product.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${widget.product.name} removed from cart'),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                          return;
                        }

                        ref.read(cartProvider.notifier).setOrUpdateProduct(
                              widget.product,
                              quantity: _quantity,
                              customization: _addonsCustomizationString,
                              price: _unitPrice,
                            );
                        widget.onAddToCart?.call(widget.product, _quantity);

                        if (widget.isEditingFromCart) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (_) => const CartScreen(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _quantity == 0
                            ? context.colorScheme.error
                            : context.colorScheme.primary,
                        foregroundColor: _quantity == 0
                            ? context.colorScheme.onError
                            : context.colorScheme.onPrimary,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_quantity == 0) ...[
                                const Icon(Icons.delete_outline_rounded, size: 20),
                                const SizedBox(width: 6),
                              ],
                              Text(
                                _quantity == 0
                                    ? 'Remove'
                                    : (widget.isEditingFromCart ? 'Update Cart' : context.l10n.viewCart),
                                style: TextStyle(
                                  fontFamily: AppTypography.fontFamily,
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w700,
                                  color: _quantity == 0
                                      ? context.colorScheme.onError
                                      : context.colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Exact Stepper layout from Figma: [-] (2x/cup) [+] with zero removal support
  Widget _buildFigmaStepper() {
    final isExistingInCart = ref.watch(cartProvider).items.any((i) => i.productId == widget.product.id);
    final canReduceToZero = isExistingInCart || widget.isEditingFromCart;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus Button
          _buildStepButton(
            icon: (_quantity == 1 && canReduceToZero)
                ? Icons.delete_outline_rounded
                : Icons.remove,
            iconColor: (_quantity == 1 && canReduceToZero)
                ? context.colorScheme.error
                : (_quantity == 0 ? context.colorScheme.outlineVariant : null),
            onTap: () {
              if (_quantity > 1) {
                setState(() => _quantity--);
              } else if (_quantity == 1 && canReduceToZero) {
                setState(() => _quantity = 0);
              }
            },
          ),

          const SizedBox(width: 10),

          // Center: Quantity text above coffee cup icon
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${_quantity}x',
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: _quantity == 0
                      ? context.colorScheme.error
                      : context.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Icon(
                _quantity == 0
                    ? Icons.delete_forever_rounded
                    : _getStepperIcon(_productType),
                size: 20,
                color: _quantity == 0
                    ? context.colorScheme.error
                    : context.colorScheme.onSurface,
              ),
            ],
          ),

          const SizedBox(width: 10),

          // Plus Button
          _buildStepButton(
            icon: Icons.add,
            onTap: () {
              setState(() => _quantity++);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStepButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Material(
      color: context.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(AppRadii.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.sm),
        onTap: onTap,
        child: SizedBox(
          width: 32,
          height: 32,
          child: Center(
            child: Icon(
              icon,
              size: 16,
              color: iconColor ?? context.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  // Customization Card (Extra milk, Iced, Light foam, French butter, etc.)
  Widget _buildAddonCard({
    required _AddonConfig addon,
  }) {
    final isSelected = _selectedAddons.contains(addon.id);
    final activeColor =
        isSelected ? context.colorScheme.primary : context.colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.cardHero),
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedAddons.remove(addon.id);
            } else {
              _selectedAddons.add(addon.id);
            }
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 106,
          height: 122,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? context.colorScheme.primary.withValues(alpha: 0.12)
                : context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(AppRadii.cardHero),
            border: Border.all(
              color: isSelected
                  ? context.colorScheme.primary
                  : context.colorScheme.outlineVariant,
              width: isSelected ? 2.0 : 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: context.colorScheme.primary.withValues(alpha: 0.20),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top-right Plus / Check Badge
              Align(
                alignment: Alignment.topRight,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.colorScheme.primary
                        : context.colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      isSelected ? Icons.check_rounded : Icons.add_rounded,
                      size: 14,
                      color: isSelected
                          ? context.colorScheme.onPrimary
                          : context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),

              // Center Custom / Material Icon
              Expanded(child: Center(child: addon.iconBuilder(activeColor))),

              // Bottom Label
              Text(
                addon.title,
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                  color: activeColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),

              // Price badge
              Text(
                addon.priceDisplay,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? context.colorScheme.primary
                      : context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// Add-on Configuration Model
// -------------------------------------------------------------

class _AddonConfig {
  final String id;
  final String title;
  final double price;
  final String priceDisplay;
  final Widget Function(Color color) iconBuilder;

  const _AddonConfig({
    required this.id,
    required this.title,
    required this.price,
    required this.priceDisplay,
    required this.iconBuilder,
  });
}

// -------------------------------------------------------------
// Authentic Vector Graphic Icons for Add-ons (Exact Figma Match)
// -------------------------------------------------------------

class _MilkCartonIcon extends StatelessWidget {
  final Color? color;
  const _MilkCartonIcon({this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 42,
      child: CustomPaint(
        painter: _MilkCartonPainter(color ?? context.colorScheme.onSurface),
      ),
    );
  }
}

class _MilkCartonPainter extends CustomPainter {
  final Color strokeColor;
  _MilkCartonPainter(this.strokeColor);

  @override
  void paint(Canvas canvas, Size size) {
    final outlinePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Right dark-filled 3D side face
    final rightFace = Path()
      ..moveTo(w * 0.52, h * 0.12)
      ..lineTo(w * 0.85, h * 0.22)
      ..lineTo(w * 0.85, h * 0.95)
      ..lineTo(w * 0.52, h * 0.95)
      ..close();
    canvas.drawPath(rightFace, fillPaint);

    // Left outlined front face
    final frontFace = Path()
      ..moveTo(w * 0.18, h * 0.22)
      ..lineTo(w * 0.52, h * 0.12)
      ..lineTo(w * 0.52, h * 0.95)
      ..lineTo(w * 0.18, h * 0.95)
      ..close();
    canvas.drawPath(frontFace, outlinePaint);

    // Gable top roof
    final gableRoof = Path()
      ..moveTo(w * 0.35, 0)
      ..lineTo(w * 0.52, h * 0.12)
      ..lineTo(w * 0.18, h * 0.22)
      ..close();
    canvas.drawPath(gableRoof, outlinePaint);

    // Circular badge in center of front face
    canvas.drawCircle(Offset(w * 0.35, h * 0.58), w * 0.12, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _IceCubesIcon extends StatelessWidget {
  final Color? color;
  const _IceCubesIcon({this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 38,
      child: CustomPaint(
        painter: _IceCubesPainter(color ?? context.colorScheme.onSurface),
      ),
    );
  }
}

class _IceCubesPainter extends CustomPainter {
  final Color color;
  _IceCubesPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Right ice cube (dark shaded)
    final rightCube = Path()
      ..moveTo(w * 0.55, h * 0.35)
      ..lineTo(w * 0.80, h * 0.25)
      ..lineTo(w * 0.92, h * 0.55)
      ..lineTo(w * 0.65, h * 0.80)
      ..close();
    canvas.drawPath(rightCube, fillPaint);

    // Left ice cube (top face)
    final leftTop = Path()
      ..moveTo(w * 0.12, h * 0.40)
      ..lineTo(w * 0.38, h * 0.22)
      ..lineTo(w * 0.60, h * 0.35)
      ..lineTo(w * 0.35, h * 0.52)
      ..close();
    canvas.drawPath(leftTop, strokePaint);

    // Left ice cube (front face)
    final leftFront = Path()
      ..moveTo(w * 0.12, h * 0.40)
      ..lineTo(w * 0.35, h * 0.52)
      ..lineTo(w * 0.35, h * 0.80)
      ..lineTo(w * 0.12, h * 0.68)
      ..close();
    canvas.drawPath(leftFront, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LightFoamIcon extends StatelessWidget {
  final Color? color;
  const _LightFoamIcon({this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: CustomPaint(
        painter: _LightFoamPainter(color ?? context.colorScheme.onSurface),
      ),
    );
  }
}

class _LightFoamPainter extends CustomPainter {
  final Color color;
  _LightFoamPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Cup outline
    final cup = Path()
      ..moveTo(w * 0.22, h * 0.25)
      ..lineTo(w * 0.78, h * 0.25)
      ..lineTo(w * 0.68, h * 0.85)
      ..lineTo(w * 0.32, h * 0.85)
      ..close();
    canvas.drawPath(cup, paint);

    // Foam level curve
    canvas.drawLine(
      Offset(w * 0.26, h * 0.48),
      Offset(w * 0.74, h * 0.48),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CaramelIcon extends StatelessWidget {
  final Color? color;
  const _CaramelIcon({this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.water_drop_outlined,
      size: 28,
      color: color ?? context.colorScheme.onSurface,
    );
  }
}

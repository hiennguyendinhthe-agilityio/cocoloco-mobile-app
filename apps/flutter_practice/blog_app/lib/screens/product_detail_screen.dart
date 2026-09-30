import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/product.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final Function(Product product, int quantity) onAddToCart;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 2; // Matching Figma demo state (2x)
  final Set<String> _selectedAddons = {};

  double get _totalPrice => widget.product.price * _quantity;

  Widget _buildHeroImage() {
    final url = widget.product.imageUrl;
    final hasNetworkUrl = url != null &&
        url.isNotEmpty &&
        (url.startsWith('http://') || url.startsWith('https://'));

    if (hasNetworkUrl) {
      return Hero(
        tag: 'hero_image_${widget.product.id}',
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          alignment: const Alignment(0, 0.2),
          placeholder: (_, _) => Container(
            color: AppColors.surfaceMuted,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
          ),
          errorWidget: (_, _, _) => Image.asset(
            widget.product.imageAsset,
            fit: BoxFit.cover,
            alignment: const Alignment(0, 0.2),
          ),
        ),
      );
    }

    return Hero(
      tag: 'hero_image_${widget.product.id}',
      child: Image.asset(
        widget.product.imageAsset,
        fit: BoxFit.cover,
        alignment: const Alignment(0, 0.2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Hero Image Section
                Stack(
                  children: [
                    // Product Image
                    SizedBox(
                      height: 350,
                      width: double.infinity,
                      child: _buildHeroImage(),
                    ),

                    // Back Arrow Button (White icon on top-left)
                    Positioned(
                      top: topPadding + 6,
                      left: 14,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () => Navigator.of(context).pop(),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Overlapping White Body Container with large top rounded corners
                Transform.translate(
                  offset: const Offset(0, -32),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 120),
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
                                    style: const TextStyle(
                                      fontFamily: AppTypography.fontFamily,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.priceMuted,
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
                          style: const TextStyle(
                            fontSize: 14.5,
                            height: 1.48,
                            color: Color(0xFF4A443E),
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
                              _buildAddonCard(
                                id: 'extra_milk',
                                title: 'Extra milk',
                                icon: const _MilkCartonIcon(),
                              ),
                              const SizedBox(width: 14),
                              _buildAddonCard(
                                id: 'iced',
                                title: 'Iced',
                                icon: const _IceCubesIcon(),
                              ),
                              const SizedBox(width: 14),
                              _buildAddonCard(
                                id: 'light_foam',
                                title: 'Light foam',
                                icon: const _LightFoamIcon(),
                              ),
                              const SizedBox(width: 14),
                              _buildAddonCard(
                                id: 'caramel_drizzle',
                                title: 'Caramel',
                                icon: const _CaramelIcon(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Bar (Seamlessly integrated, exactly aligned with body 24px margins)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(24, 16, 24, 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left: Price & Quantity Label - exactly aligned with left margin (24px)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${_totalPrice.toInt()}\$',
                        style: const TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textDark,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${_quantity}x ${widget.product.name}',
                        style: const TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.priceMuted,
                        ),
                      ),
                    ],
                  ),

                  // Right: "View cart" Button (Proportional 176px width x 54px height per Figma)
                  SizedBox(
                    width: 176,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        widget.onAddToCart(widget.product, _quantity);
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (_) => CartScreen(
                              initialItems: [
                                CartItem(
                                  id: 'item_${widget.product.id}',
                                  name: widget.product.name,
                                  customization: 'With extra milk',
                                  quantity: _quantity,
                                  price: 4.0,
                                  titleColor: widget.product.titleColor,
                                ),
                                const CartItem(
                                  id: 'item_toast',
                                  name: 'Toast',
                                  customization: 'With avocado',
                                  quantity: 2,
                                  price: 6.0,
                                  titleColor: AppColors.croissantBlue,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        'View cart',
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
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

  // Exact Stepper layout from Figma: [-] (2x/cup) [+]
  Widget _buildFigmaStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus Button
          _buildStepButton(
            icon: Icons.remove,
            onTap: () {
              if (_quantity > 1) {
                setState(() => _quantity--);
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
                style: const TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              const Icon(
                Icons.coffee_rounded,
                size: 20,
                color: AppColors.textDark,
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
  }) {
    return Material(
      color: const Color(0xFFF4F0E8),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: SizedBox(
          width: 32,
          height: 32,
          child: Center(
            child: Icon(icon, size: 16, color: const Color(0xFF4A4541)),
          ),
        ),
      ),
    );
  }

  // Customization Card (Extra milk, Iced, Light foam)
  Widget _buildAddonCard({
    required String id,
    required String title,
    required Widget icon,
  }) {
    final isSelected = _selectedAddons.contains(id);

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedAddons.remove(id);
          } else {
            _selectedAddons.add(id);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 106,
        height: 118,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFDFBF7) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFECE7DE),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top-right Plus / Check Badge
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFFF9EEEE),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    isSelected ? Icons.check : Icons.add,
                    size: 13,
                    color: isSelected ? Colors.white : const Color(0xFFD8555F),
                  ),
                ),
              ),
            ),

            // Center Custom Icon
            Expanded(child: Center(child: icon)),

            // Bottom Label
            Text(
              title,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.primary : AppColors.textDark,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// Authentic Vector Graphic Icons for Add-ons (Exact Figma Match)
// -------------------------------------------------------------

class _MilkCartonIcon extends StatelessWidget {
  const _MilkCartonIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 42,
      child: CustomPaint(painter: _MilkCartonPainter()),
    );
  }
}

class _MilkCartonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const strokeColor = Color(0xFF3C3633);
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
  const _IceCubesIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 38,
      child: CustomPaint(painter: _IceCubesPainter()),
    );
  }
}

class _IceCubesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const color = Color(0xFF3C3633);
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
  const _LightFoamIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: CustomPaint(painter: _LightFoamPainter()),
    );
  }
}

class _LightFoamPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const color = Color(0xFF3C3633);
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
  const _CaramelIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.water_drop_outlined,
      size: 28,
      color: Color(0xFF3C3633),
    );
  }
}

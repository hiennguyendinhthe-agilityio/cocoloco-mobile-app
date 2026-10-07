import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/services/session_service.dart';
import '../core/theme/app_theme.dart';
import '../data/providers/cart_provider.dart';
import '../models/user_profile.dart';
import '../screens/cart_screen.dart';
import '../screens/profile_screen.dart';

class CocolocoHeader extends StatelessWidget {
  final VoidCallback onSearchTap;

  const CocolocoHeader({
    super.key,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Authentic Figma COCO LOCO Logo (Width: 94px, Height: 64px per Figma spec)
          SizedBox(
            width: 94,
            height: 64,
            child: Image.asset(
              'assets/images/cocoloco_logo.png',
              width: 94,
              height: 64,
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
              color: isDark ? context.colorScheme.primary : null,
              errorBuilder: (_, __, ___) => _buildFigmaTextLogo(context),
            ),
          ),

          Row(
            children: [
              // Search Action Icon
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: onSearchTap,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.search_rounded,
                      color: context.colorScheme.primary,
                      size: 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),

              // Cart Action Icon with Dynamic Badge
              Consumer(
                builder: (context, ref, _) {
                  final cartCount = ref.watch(cartProvider.select((s) => s.totalItemCount));

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CartScreen()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Badge(
                          isLabelVisible: cartCount > 0,
                          backgroundColor: const Color(0xFFD9534F),
                          textColor: Colors.white,
                          textStyle: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          label: Text('$cartCount'),
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            color: context.colorScheme.primary,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 6),
              // Profile Action Icon / Avatar
              ListenableBuilder(
                listenable: SessionService.instance,
                builder: (context, _) {
                  final session = SessionService.instance;
                  final isLoggedIn = session.isLoggedIn;
                  final user = session.user;
                  final avatarUrl = user?.avatarUrl;
                  final hasAvatar = isLoggedIn && avatarUrl != null && avatarUrl.isNotEmpty;

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: hasAvatar
                            ? Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: context.colorScheme.primary.withValues(alpha: 0.35),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: context.colorScheme.primary.withValues(alpha: 0.15),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    avatarUrl,
                                    width: 36,
                                    height: 36,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        _buildFallbackAvatar(context, isLoggedIn, user),
                                  ),
                                ),
                              )
                            : _buildFallbackAvatar(context, isLoggedIn, user),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackAvatar(BuildContext context, bool isLoggedIn, UserProfile? user) {
    if (isLoggedIn) {
      final initial = (user?.fullName.isNotEmpty == true)
          ? user!.fullName.trim()[0].toUpperCase()
          : 'U';

      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: context.colorScheme.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.primary.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            initial,
            style: TextStyle(
              color: context.colorScheme.onPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person_outline_rounded,
        color: context.colorScheme.primary,
        size: 24,
      ),
    );
  }

  // Exact fallback typography according to Figma inspect:
  Widget _buildFigmaTextLogo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        Text(
          'COCO\nLOCO',
          style: GoogleFonts.lilitaOne(
            fontSize: 32,
            height: 1.0,
            letterSpacing: 0,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2.0
              ..strokeJoin = StrokeJoin.round
              ..strokeCap = StrokeCap.round
              ..color = isDark ? Colors.white24 : Colors.black,
          ),
        ),
        Text(
          'COCO\nLOCO',
          style: GoogleFonts.lilitaOne(
            fontSize: 32,
            height: 1.0,
            letterSpacing: 0,
            color: context.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/services/session_service.dart';
import '../core/theme/app_colors.dart';
import '../models/user_profile.dart';
import '../screens/profile_screen.dart';

class CocolocoHeader extends StatelessWidget {
  final VoidCallback onSearchTap;

  const CocolocoHeader({
    super.key,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
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
              errorBuilder: (_, _, _) => _buildFigmaTextLogo(),
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
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.search_rounded,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
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
                                    color: AppColors.primary.withValues(alpha: 0.25),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.12),
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
                                        _buildFallbackAvatar(isLoggedIn, user),
                                  ),
                                ),
                              )
                            : _buildFallbackAvatar(isLoggedIn, user),
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

  Widget _buildFallbackAvatar(bool isLoggedIn, UserProfile? user) {
    if (isLoggedIn) {
      final initial = (user?.fullName.isNotEmpty == true)
          ? user!.fullName.trim()[0].toUpperCase()
          : 'U';

      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            initial,
            style: const TextStyle(
              color: Colors.white,
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
        color: AppColors.primary.withValues(alpha: 0.05),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person_outline_rounded,
        color: AppColors.primary,
        size: 24,
      ),
    );
  }

  // Exact fallback typography according to Figma inspect:
  // Font: Chap, Weight: 900, Size: 32px, Line height: 32px, Color: #5B1921, Border: 1px #000000 outer
  Widget _buildFigmaTextLogo() {
    return Stack(
      children: [
        // 1px Outer Black Border/Stroke (#000000)
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
              ..color = Colors.black,
          ),
        ),
        // Primary Burgundy Fill (#5B1921)
        Text(
          'COCO\nLOCO',
          style: GoogleFonts.lilitaOne(
            fontSize: 32,
            height: 1.0,
            letterSpacing: 0,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

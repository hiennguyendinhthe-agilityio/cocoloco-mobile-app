import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class CocolocoBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final int cartItemCount;

  const CocolocoBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
    this.cartItemCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: Container(
          color: AppColors.background.withValues(alpha: 0.85),
          padding: const EdgeInsets.only(top: 8, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            index: 0,
            activeIcon: Icons.home_rounded,
            inactiveIcon: Icons.home_outlined,
          ),
          _buildNavItem(
            index: 1,
            activeIcon: Icons.favorite_rounded,
            inactiveIcon: Icons.favorite_border_rounded,
          ),
          _buildNavItem(
            index: 2,
            activeIcon: Icons.shopping_bag_rounded,
            inactiveIcon: Icons.shopping_bag_outlined,
            badgeCount: cartItemCount,
          ),
          _buildNavItem(
            index: 3,
            activeIcon: Icons.receipt_long_rounded,
            inactiveIcon: Icons.receipt_long_outlined,
          ),
          _buildNavItem(
            index: 4,
            activeIcon: Icons.person_rounded,
            inactiveIcon: Icons.person_outline_rounded,
          ),
        ],
      ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData activeIcon,
    required IconData inactiveIcon,
    int badgeCount = 0,
  }) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onIndexChanged(index),
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.navActiveCircle : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                isSelected ? activeIcon : inactiveIcon,
                color: isSelected ? Colors.white : AppColors.navInactive,
                size: isSelected ? 26 : 28,
              ),
            ),
          ),
          if (badgeCount > 0)
            Positioned(
              top: 2,
              right: 2,
              child: AnimatedScale(
                scale: 1.0,
                duration: const Duration(milliseconds: 150),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Center(
                    child: Text(
                      badgeCount > 9 ? '9+' : '$badgeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

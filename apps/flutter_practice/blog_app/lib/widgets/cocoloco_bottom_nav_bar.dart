import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class CocolocoBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;

  const CocolocoBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
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
                activeIcon: Icons.inventory_2_rounded, // Box/Cube icon
                inactiveIcon: Icons.inventory_2_outlined,
              ),
              _buildNavItem(
                index: 3,
                activeIcon: Icons.chat_bubble_rounded,
                inactiveIcon: Icons.chat_bubble_outline_rounded,
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
  }) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onIndexChanged(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
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
    );
  }
}

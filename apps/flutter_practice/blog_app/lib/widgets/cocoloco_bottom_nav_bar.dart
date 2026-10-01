import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

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
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: Container(
          color: scaffoldBg.withValues(alpha: 0.95),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context: context,
                    index: 0,
                    activeIcon: Icons.home_rounded,
                    inactiveIcon: Icons.home_outlined,
                  ),
                  _buildNavItem(
                    context: context,
                    index: 1,
                    activeIcon: Icons.favorite_rounded,
                    inactiveIcon: Icons.favorite_border_rounded,
                  ),
                  _buildNavItem(
                    context: context,
                    index: 2,
                    activeIcon: Icons.inventory_2_rounded, // Box/Cube icon
                    inactiveIcon: Icons.inventory_2_outlined,
                  ),
                  _buildNavItem(
                    context: context,
                    index: 3,
                    activeIcon: Icons.chat_bubble_rounded,
                    inactiveIcon: Icons.chat_bubble_outline_rounded,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData activeIcon,
    required IconData inactiveIcon,
  }) {
    final bool isSelected = currentIndex == index;
    final cocolocoColors = context.cocolocoColors;

    return GestureDetector(
      onTap: () => onIndexChanged(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: isSelected ? cocolocoColors.navActiveCircle : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            isSelected ? activeIcon : inactiveIcon,
            color: isSelected ? Colors.white : cocolocoColors.navInactive,
            size: isSelected ? 26 : 28,
          ),
        ),
      ),
    );
  }
}

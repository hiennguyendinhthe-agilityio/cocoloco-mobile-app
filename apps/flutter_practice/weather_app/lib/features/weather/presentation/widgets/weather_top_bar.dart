import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_app/theme/theme_context_ext.dart';

class WeatherTopBar extends StatelessWidget {
  final String cityName;
  final VoidCallback onSearchPressed;

  const WeatherTopBar({
    super.key,
    required this.cityName,
    required this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      centerTitle: true,
      toolbarHeight: 64,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on,
            color: context.glass.iconPrimary,
            size: 18,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              cityName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: context.glass.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 18,
                shadows: const [
                  Shadow(blurRadius: 8, color: Colors.black38),
                ],
              ),
            ),
          ),
        ],
      ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.3, end: 0),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: Icon(
              Icons.search_rounded,
              color: context.glass.iconPrimary,
            ),
            onPressed: onSearchPressed,
            style: IconButton.styleFrom(
              backgroundColor: context.glass.searchBackground,
              shape: const CircleBorder(),
            ),
          ).animate().fadeIn(duration: 600.ms),
        ),
      ],
    );
  }
}

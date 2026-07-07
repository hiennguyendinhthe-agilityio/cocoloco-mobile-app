import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_app/core/extensions/l10n_extension.dart';
import 'package:weather_app/theme/theme_context_ext.dart';

class WeatherErrorState extends StatelessWidget {
  final VoidCallback onSearchPressed;

  const WeatherErrorState({super.key, required this.onSearchPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 16,
          right: 16,
          child: IconButton(
            icon: Icon(
              Icons.search_rounded,
              color: context.glass.iconPrimary,
              size: 28,
            ),
            onPressed: onSearchPressed,
            style: IconButton.styleFrom(
              backgroundColor: context.glass.searchBackground,
              shape: const CircleBorder(),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off_rounded,
                size: 72,
                color: context.glass.iconSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.tryAnotherSearch,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.glass.textSecondary,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ],
          ).animate().shake(hz: 2, duration: 500.ms).fadeIn(),
        ),
      ],
    );
  }
}

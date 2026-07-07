import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_app/core/extensions/l10n_extension.dart';
import 'package:weather_app/theme/theme_context_ext.dart';

class WeatherInitialState extends StatelessWidget {
  final VoidCallback onSearchPressed;

  const WeatherInitialState({super.key, required this.onSearchPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top search button
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
                Icons.wb_sunny_outlined,
                color: context.glass.iconSecondary,
                size: 80,
              ),
              const SizedBox(height: 20),
              Text(
                context.l10n.tapToSearch,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.glass.textSecondary,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 800.ms).scale(
            begin: const Offset(0.8, 0.8),
            duration: 800.ms,
            curve: Curves.easeOut,
          ),
        ),
      ],
    );
  }
}

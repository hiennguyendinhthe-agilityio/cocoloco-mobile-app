import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_app/core/extensions/l10n_extension.dart';
import 'package:weather_app/theme/theme_context_ext.dart';

class WeatherErrorState extends StatelessWidget {
  final Object error;
  final VoidCallback onSearchPressed;

  const WeatherErrorState({
    super.key, 
    required this.error,
    required this.onSearchPressed,
  });

  String _getUserFriendlyErrorMessage(Object error) {
    // In a real app, you'd map exceptions to specific l10n strings
    // For now, we clean up the Exception prefix for a better UI
    final errStr = error.toString();
    if (errStr.contains('SocketException') || errStr.contains('Failed to host lookup')) {
      return 'No internet connection. Please check your network and try again.';
    }
    if (errStr.startsWith('Exception: ')) {
      return errStr.substring(11);
    }
    return errStr;
  }

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_off_rounded,
                  size: 72,
                  color: context.colors.error,
                ),
                const SizedBox(height: 24),
                Text(
                  _getUserFriendlyErrorMessage(error),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.glass.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  context.l10n.tryAnotherSearch,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.glass.textSecondary,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: onSearchPressed,
                  icon: const Icon(Icons.search),
                  label: const Text('Search City'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary.withValues(alpha: 0.8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                )
              ],
            ).animate().shake(hz: 2, duration: 500.ms).fadeIn(),
          ),
        ),
      ],
    );
  }
}

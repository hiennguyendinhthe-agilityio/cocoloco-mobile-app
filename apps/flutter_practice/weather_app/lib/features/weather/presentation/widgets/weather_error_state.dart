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

  String _getUserFriendlyError(BuildContext context, dynamic error) {
    if (error == null) return context.l10n.unknown;

    // In a real app, you'd map exceptions to specific l10n strings
    // Here we do a simple check for common network errors
    final errStr = error.toString();
    if (errStr.contains('SocketException') || errStr.contains('Failed to host lookup')) {
      return context.l10n.noInternetConnection;
    }
    if (errStr.startsWith('Exception: ')) {
      return errStr.replaceFirst('Exception: ', '');
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
                  _getUserFriendlyError(context, error),
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
                  label: Text(context.l10n.searchCityBtn),
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

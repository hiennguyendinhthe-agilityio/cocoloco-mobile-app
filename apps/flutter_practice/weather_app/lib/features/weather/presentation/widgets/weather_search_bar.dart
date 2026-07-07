import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/core/extensions/l10n_extension.dart';
import 'package:weather_app/features/weather/presentation/providers/forecast_provider.dart';
import 'package:weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:weather_app/theme/theme_context_ext.dart';

class WeatherSearchBar extends ConsumerStatefulWidget {
  final VoidCallback? onSubmitted;

  const WeatherSearchBar({super.key, this.onSubmitted});

  @override
  ConsumerState<WeatherSearchBar> createState() => _WeatherSearchBarState();
}

class _WeatherSearchBarState extends ConsumerState<WeatherSearchBar> {
  final _controller = TextEditingController();
  bool _hasFocus = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      ref.read(weatherProvider.notifier).fetchWeather(text);
      ref.read(forecastProvider.notifier).fetchForecast(text);
      FocusScope.of(context).unfocus();
      widget.onSubmitted?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: _hasFocus
                    ? context.glass.backgroundHighlight
                    : context.glass.searchBackground,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: context.glass.border, width: 1.5),
              ),
              child: Focus(
                onFocusChange: (focused) => setState(() => _hasFocus = focused),
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.search,
                  style: TextStyle(color: context.glass.textPrimary),
                  decoration: InputDecoration(
                    hintText: context.l10n.searchCityHint,
                    hintStyle: TextStyle(color: context.glass.textSecondary),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: context.glass.iconSecondary,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                      ),
                      color: context.glass.iconPrimary,
                      onPressed: _submit,
                    ),
                    filled: false,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  onSubmitted: (_) => _submit(),
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(
          begin: -0.4,
          end: 0,
          curve: Curves.easeOutCubic,
          duration: 600.ms,
        );
  }
}

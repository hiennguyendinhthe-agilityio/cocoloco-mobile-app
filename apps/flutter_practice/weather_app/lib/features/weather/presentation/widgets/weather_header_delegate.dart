import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_main_info.dart';

class WeatherHeaderDelegate extends SliverPersistentHeaderDelegate {
  final WeatherEntity weather;
  final double expandedHeight;
  final VoidCallback onSearchPressed;

  const WeatherHeaderDelegate({
    required this.weather,
    required this.expandedHeight,
    required this.onSearchPressed,
  });

  @override
  double get minExtent => kToolbarHeight + 47.0;

  @override
  double get maxExtent => expandedHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final maxExt = maxExtent;
    final minExt = kToolbarHeight + topPadding;
    final shrinkPercent = (shrinkOffset / (maxExt - minExt)).clamp(0.0, 1.0);
    final expandPercent = 1.0 - shrinkPercent;

    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: expandPercent,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: OverflowBox(
                  minHeight: 0,
                  maxHeight: double.infinity,
                  alignment: Alignment.bottomLeft,
                  child: WeatherMainInfo(weather: weather),
                ),
              ),
            ),
          ),
          if (shrinkPercent > 0)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: minExt,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 20.0 * shrinkPercent,
                    sigmaY: 20.0 * shrinkPercent,
                  ),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.4 * shrinkPercent),
                  ),
                ),
              ),
            ),
          Positioned(
            top: topPadding,
            left: 0,
            right: 0,
            height: kToolbarHeight,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu_rounded, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white70,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            weather.cityName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(blurRadius: 6, color: Colors.black38),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Opacity(
                          opacity: shrinkPercent,
                          child: Text(
                            '${weather.temperature.toStringAsFixed(0)}°',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search_rounded, color: Colors.white),
                  onPressed: onSearchPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(WeatherHeaderDelegate oldDelegate) {
    return oldDelegate.weather != weather ||
        oldDelegate.expandedHeight != expandedHeight;
  }
}

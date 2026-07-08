import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:weather_app/features/weather/presentation/widgets/app_drawer.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_background.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_daily_forecast_card.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_error_state.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_gradient_overlay.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_header_delegate.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_hourly_forecast_card.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_initial_state.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_loading_state.dart';
import 'package:weather_app/features/weather/presentation/widgets/search/weather_search_overlay.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_stats_card.dart';
import 'package:weather_app/features/weather/presentation/widgets/shooting_star_overlay.dart';
import 'package:weather_app/theme/theme_context_ext.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _searchAnimController;

  @override
  void initState() {
    super.initState();
    _searchAnimController = AnimationController(vsync: this, duration: 300.ms);
  }

  @override
  void dispose() {
    _searchAnimController.dispose();
    super.dispose();
  }

  void _openSearch() {
    _searchAnimController.forward();
  }

  void _closeSearch() {
    FocusScope.of(context).unfocus();
    _searchAnimController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherProvider);
    final weather = weatherState.value;

    return Scaffold(
      backgroundColor: context.colors.surface,
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      body: AnimatedBuilder(
        animation: _searchAnimController,
        child: SafeArea(
          bottom: false,
          child: weatherState.when(
            data: (w) => w == null
                ? WeatherInitialState(onSearchPressed: _openSearch)
                : _buildWeatherLayout(w),
            loading: () => const WeatherLoadingState(),
            error: (e, _) => WeatherErrorState(
              error: e,
              onSearchPressed: _openSearch,
            ),
          ),
        ),
        builder: (context, child) {
          final isSearching = !_searchAnimController.isDismissed;
          // Scale from 1.0 to 0.96 (a bit less extreme than 0.98 for visual clarity)
          final scale = 1.0 - (_searchAnimController.value * 0.04);
          final overlayOpacity = _searchAnimController.value;

          return Stack(
            children: [
              // ── Layer 1: Background (Fixed, NO SCALE) ───────────────────
              Positioned.fill(child: WeatherBackground(weather: weather)),
              Positioned.fill(child: WeatherGradientOverlay(weather: weather)),

              // ── Layer 1.5: Shooting Stars (Only at night) ───────────────────
              if (weather != null && weather.iconCode.endsWith('n'))
                const Positioned.fill(
                  child: ShootingStarOverlay(),
                ),

              // ── Layer 2: Main UI (Scaled) ───────────────────────────────
              Transform.scale(
                scale: scale,
                alignment: Alignment.center,
                child: child!, // Use the pre-built child to avoid rebuilding every frame
              ),

              // ── Layer 3: Dark Frosted Glass Overlay ────────────────────
              if (isSearching)
                Positioned.fill(
                  child: Opacity(
                    opacity: overlayOpacity,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: GestureDetector(
                        onTap: _closeSearch,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.3), // slightly darker for better contrast
                        ),
                      ),
                    ),
                  ),
                ),

              // ── Layer 4: New Search UI (Smooth transition) ─────────────
              if (isSearching)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Opacity(
                    opacity: overlayOpacity,
                    child: IgnorePointer(
                      ignoring: _searchAnimController.isDismissed,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.03), // Slide up gently from below
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _searchAnimController,
                          curve: Curves.easeOutCubic,
                        )),
                        child: WeatherSearchOverlay(
                          onCancel: _closeSearch,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWeatherLayout(WeatherEntity w) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Collapsing Header (Blur + Fade technique) ─────────────────
        SliverPersistentHeader(
          pinned: true,
          delegate: WeatherHeaderDelegate(
            weather: w,
            expandedHeight: 300.0,
            onSearchPressed: _openSearch,
          ),
        ),

        // ── Cards (Stats, Hourly, Daily) ───────────────────────────────
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(
                height: 64,
              ), // Push cards down to create more space below the date text
              WeatherStatsCard(weather: w),
              const WeatherHourlyForecastCard(),
              const WeatherDailyForecastCard(),
              const SizedBox(height: 32), // Padding at bottom
            ],
          ),
        ),
      ],
    );
  }
}

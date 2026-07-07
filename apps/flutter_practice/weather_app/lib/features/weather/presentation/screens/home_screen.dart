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
import 'package:weather_app/features/weather/presentation/widgets/weather_search_bar.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_stats_card.dart';
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
      body: Stack(
        children: [
          // ── Layer 1: Landscape illustration ────────────────────────────
          Positioned.fill(child: WeatherBackground(weather: weather)),

          // ── Layer 2: Gradient overlay (top dark, bottom light) ─────────
          Positioned.fill(child: WeatherGradientOverlay(weather: weather)),

          // ── Layer 3: Main UI (Slivers) ─────────────────────────────────
          SafeArea(
            bottom: false,
            child: weatherState.when(
              data: (w) => w == null
                  ? WeatherInitialState(onSearchPressed: _openSearch)
                  : _buildWeatherLayout(w),
              loading: () => const WeatherLoadingState(),
              error: (e, _) => WeatherErrorState(onSearchPressed: _openSearch),
            ),
          ),

          // ── Layer 4: Tap outside to close ──────────────────────────────
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _searchAnimController,
              builder: (context, child) {
                if (_searchAnimController.isDismissed) {
                  return const SizedBox.shrink();
                }
                return GestureDetector(
                  onTap: _closeSearch,
                  behavior: HitTestBehavior.translucent,
                  child: Container(color: Colors.transparent),
                );
              },
            ),
          ),

          // ── Layer 5: Search overlay (Animated) ─────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _searchAnimController,
              builder: (context, child) {
                return IgnorePointer(
                  ignoring: _searchAnimController.isDismissed,
                  child: child,
                );
              },
              child: Animate(
                controller: _searchAnimController,
                autoPlay: false,
                effects: [
                  SlideEffect(
                    begin: const Offset(0, -1),
                    end: Offset.zero,
                    duration: 350.ms,
                    curve: Curves.easeOutCubic,
                  ),
                ],
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      color: Colors.black.withAlpha(150),
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: WeatherSearchBar(
                                  onSubmitted: _closeSearch,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: context.glass.iconPrimary,
                                ),
                                onPressed: _closeSearch,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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

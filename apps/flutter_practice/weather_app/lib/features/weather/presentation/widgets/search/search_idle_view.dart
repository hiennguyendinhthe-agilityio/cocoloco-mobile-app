import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/core/extensions/l10n_extension.dart';
import 'package:weather_app/features/weather/domain/entities/location_entity.dart';
import 'package:weather_app/features/weather/presentation/providers/forecast_provider.dart';
import 'package:weather_app/features/weather/presentation/providers/location_service_provider.dart';
import 'package:weather_app/features/weather/presentation/providers/search_providers.dart';
import 'package:weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:weather_app/features/weather/presentation/widgets/search/city_list_item.dart';
import 'package:weather_app/theme/theme_context_ext.dart';

class SearchIdleView extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const SearchIdleView({super.key, required this.onClose});

  @override
  ConsumerState<SearchIdleView> createState() => _SearchIdleViewState();
}

class _SearchIdleViewState extends ConsumerState<SearchIdleView> {
  bool _isLocating = false;

  Future<void> _handleCurrentLocation() async {
    if (_isLocating) return;

    setState(() {
      _isLocating = true;
    });

    try {
      final locationService = ref.read(locationServiceProvider);
      final position = await locationService.getCurrentPosition();

      // Get a nice city name instead of default OWM village names
      final niceCityName = await locationService.getCityNameFromPosition(
        position,
      );

      // Fetch weather by coordinates, overriding the display name if we found a better one
      ref
          .read(weatherProvider.notifier)
          .fetchWeatherByCoord(
            position.latitude,
            position.longitude,
            cityNameOverride: niceCityName,
          );
      ref
          .read(forecastProvider.notifier)
          .fetchForecastByCoord(
            position.latitude,
            position.longitude,
            cityNameOverride: niceCityName,
          );

      // We don't save "Current Location" to recent searches for privacy/logic reasons
      ref.read(searchQueryProvider.notifier).state = '';
      widget.onClose();
    } catch (e) {
      // Handle error gracefully (e.g., show a snackbar)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.couldNotAccessLocation(e.toString().split('\n')[0]),
            ),
            backgroundColor: context.colors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLocating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final recentSearchesState = ref.watch(recentSearchesProvider);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        // Current Location (Pinned)
        _buildSectionTitle(context.l10n.currentLocation, null),
        const SizedBox(height: 12),
        _buildCurrentLocationCard(context),
        const SizedBox(height: 32),

        // Recent Searches
        if (recentSearchesState.value != null &&
            recentSearchesState.value!.isNotEmpty) ...[
          _buildSectionTitle(context.l10n.recentSearches, () {
            ref.read(recentSearchesProvider.notifier).clearRecentSearches();
          }),
          const SizedBox(height: 12),
          ...recentSearchesState.value!.map(
            (location) => CityListItem(
              city: location.name,
              country: location.country,
              temperature:
                  '--', // Not saving temperature in location entity to save space/sync
              weatherIcon:
                  Icons.history, // A generic history icon instead of weather
              leadingIcon: Icons.location_on,
              onDelete: () {
                ref
                    .read(recentSearchesProvider.notifier)
                    .removeRecentSearch(location);
              },
              onTap: () => _onLocationTap(ref, location),
            ),
          ),
          const SizedBox(height: 32),
        ],

        // Popular Cities
        _buildSectionTitle(context.l10n.popularCities, null),
        const SizedBox(height: 12),
        CityListItem(
          city: context.l10n.tokyo,
          country: 'JP',
          temperature: '--',
          weatherIcon: Icons.star_border,
          onTap: () => _onLocationTap(
            ref,
            LocationEntity(
              name: context.l10n.tokyo,
              lat: 35.6895,
              lon: 139.6917,
              country: 'JP',
            ),
          ),
        ),
        CityListItem(
          city: context.l10n.london,
          country: 'GB',
          temperature: '--',
          weatherIcon: Icons.star_border,
          onTap: () => _onLocationTap(
            ref,
            LocationEntity(
              name: context.l10n.london,
              lat: 51.5072,
              lon: -0.1276,
              country: 'GB',
            ),
          ),
        ),
        CityListItem(
          city: context.l10n.newYork,
          country: 'US',
          temperature: '--',
          weatherIcon: Icons.star_border,
          onTap: () => _onLocationTap(
            ref,
            LocationEntity(
              name: context.l10n.newYork,
              lat: 40.7128,
              lon: -74.0060,
              country: 'US',
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  void _onLocationTap(WidgetRef ref, LocationEntity location) {
    ref.read(recentSearchesProvider.notifier).addRecentSearch(location);
    ref
        .read(weatherProvider.notifier)
        .fetchWeather(
          location.name,
        ); // Using name to keep it simple, or could refactor to use lat/lon
    ref.read(forecastProvider.notifier).fetchForecast(location.name);
    ref.read(searchQueryProvider.notifier).state = '';
    widget.onClose();
  }

  Widget _buildSectionTitle(String title, VoidCallback? onClear) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: context.glass.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        if (onClear != null)
          GestureDetector(
            onTap: onClear,
            child: Text(
              context.l10n.clearBtn,
              style: TextStyle(
                color: context.colors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCurrentLocationCard(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _isLocating ? null : _handleCurrentLocation,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: context.colors.primary.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
                child: _isLocating
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: context.glass.iconPrimary,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(
                        Icons.my_location,
                        color: context.glass.iconPrimary,
                        size: 24,
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.currentLocation,
                      style: TextStyle(
                        color: context.glass.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isLocating
                          ? context.l10n.locating
                          : context.l10n.tapToFindLocation,
                      style: TextStyle(
                        color: context.glass.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

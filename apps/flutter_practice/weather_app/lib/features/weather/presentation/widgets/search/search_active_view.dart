import 'package:flutter/material.dart';
import 'package:weather_app/core/extensions/l10n_extension.dart';
import 'package:weather_app/theme/theme_context_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/features/weather/presentation/providers/search_providers.dart';
import 'package:weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:weather_app/features/weather/presentation/providers/forecast_provider.dart';
import 'package:weather_app/features/weather/presentation/widgets/search/city_list_item.dart';

class SearchActiveView extends ConsumerWidget {
  final VoidCallback onClose;

  const SearchActiveView({super.key, required this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(searchResultsProvider);

    return searchResults.when(
      data: (results) {
        if (results.isEmpty) {
          return Center(
            child: Text(
              context.l10n.noResultsFound,
              style: TextStyle(color: context.glass.textSecondary, fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: results.length,
          itemBuilder: (context, index) {
            final location = results[index];
            return CityListItem(
              city: location.name,
              country: location.country,
              temperature: '', // Omit temperature to save API calls
              weatherIcon: Icons.location_on_outlined,
              leadingIcon: null,
              onTap: () {
                ref.read(recentSearchesProvider.notifier).addRecentSearch(location);
                ref.read(weatherProvider.notifier).fetchWeather(location.name);
                ref.read(forecastProvider.notifier).fetchForecast(location.name);
                ref.read(searchQueryProvider.notifier).state = '';
                onClose();
              },
            );
          },
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(color: context.glass.iconPrimary),
      ),
      error: (error, _) => Center(
        child: Text(
          error.toString(),
          style: TextStyle(color: context.colors.error, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

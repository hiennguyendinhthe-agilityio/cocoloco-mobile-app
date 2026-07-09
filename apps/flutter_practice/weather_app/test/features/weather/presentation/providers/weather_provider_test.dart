import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/localization/locale_provider.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/domain/usecases/get_current_weather_usecase.dart';
import 'package:weather_app/features/weather/presentation/providers/weather_provider.dart';

import 'package:weather_app/core/storage/preferences_service.dart';

class MockGetCurrentWeatherUseCase extends Mock
    implements GetCurrentWeatherUseCase {}

class MockPreferencesService extends Mock implements PreferencesService {}

void main() {
  late MockGetCurrentWeatherUseCase mockUseCase;
  late MockPreferencesService mockPrefs;

  setUp(() {
    mockUseCase = MockGetCurrentWeatherUseCase();
    mockPrefs = MockPreferencesService();
    
    // Stub saveLanguageCode
    when(() => mockPrefs.saveLanguageCode(any())).thenAnswer((_) async => true);
    when(() => mockPrefs.getLanguageCode()).thenReturn('en');
  });

  final tWeather = WeatherEntity(
    cityName: 'London',
    countryCode: 'GB',
    temperature: 20.0,
    feelsLike: 19.5,
    minTemp: 18.0,
    maxTemp: 22.0,
    condition: 'Clouds',
    iconCode: '04d',
    humidity: 70,
    windSpeed: 5.0,
    lastUpdated: DateTime.now(),
    localTime: DateTime.now(),
    sunriseTime: DateTime.now(),
    sunsetTime: DateTime.now(),
  );

  ProviderContainer makeProviderContainer(MockGetCurrentWeatherUseCase useCase) {
    final container = ProviderContainer(
      overrides: [
        getCurrentWeatherUseCaseProvider.overrideWithValue(useCase),
        preferencesServiceProvider.overrideWithValue(mockPrefs),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('WeatherNotifier', () {
    test('initial state should be null', () {
      final container = makeProviderContainer(mockUseCase);
      expect(container.read(weatherProvider).value, isNull);
    });

    test('fetchWeather emits loading, then data on success', () async {
      // Arrange
      final container = makeProviderContainer(mockUseCase);
      when(() => mockUseCase.execute(city: 'London', lang: 'en'))
          .thenAnswer((_) async => tWeather);

      // Act
      final fetchFuture = container
          .read(weatherProvider.notifier)
          .fetchWeather('London');

      // Verify loading state
      expect(container.read(weatherProvider).isLoading, true);

      await fetchFuture;

      // Assert data state
      expect(container.read(weatherProvider).value, tWeather);
      verify(() => mockUseCase.execute(city: 'London', lang: 'en')).called(1);
    });

    test('fetchWeather emits error on failure', () async {
      // Arrange
      final container = makeProviderContainer(mockUseCase);
      final exception = Exception('Network error');
      when(() => mockUseCase.execute(city: 'London', lang: 'en'))
          .thenThrow(exception);

      // Act
      await container.read(weatherProvider.notifier).fetchWeather('London');

      // Assert error state
      final state = container.read(weatherProvider);
      expect(state.hasError, true);
      expect(state.error, exception);
    });

    test('should automatically refetch when localeProvider changes', () async {
      // Arrange
      final container = makeProviderContainer(mockUseCase);
      
      // Simulate first fetch in English
      when(() => mockUseCase.execute(city: 'London', lang: 'en'))
          .thenAnswer((_) async => tWeather);
      await container.read(weatherProvider.notifier).fetchWeather('London');
      expect(container.read(weatherProvider).value?.cityName, 'London');
      
      // Prepare localized response
      final tWeatherVi = tWeather.copyWith(condition: 'Mây đen u ám');
      when(() => mockUseCase.execute(city: 'London', lang: 'vi'))
          .thenAnswer((_) async => tWeatherVi);

      // Act: change locale
      await container.read(localeProvider.notifier).setLocale(const Locale('vi'));
      
      // Wait for async operations to complete
      await Future.delayed(Duration.zero);

      // Assert: fetchWeather should be called again with lang='vi'
      verify(() => mockUseCase.execute(city: 'London', lang: 'vi')).called(1);
      
      // Assert: state should hold the updated localized weather
      expect(container.read(weatherProvider).value?.condition, 'Mây đen u ám');
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/get_current_weather_by_coord_usecase.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late GetCurrentWeatherByCoordUseCase useCase;
  late MockWeatherRepository mockRepository;

  final tNow = DateTime(2024, 7, 15, 12, 0);
  final tWeather = WeatherEntity(
    cityName: 'London',
    countryCode: 'GB',
    temperature: 20.0,
    feelsLike: 21.0,
    minTemp: 18.0,
    maxTemp: 22.0,
    condition: 'Clear',
    iconCode: '01d',
    humidity: 50,
    windSpeed: 5.0,
    lastUpdated: tNow,
    localTime: tNow,
    sunriseTime: tNow,
    sunsetTime: tNow,
  );

  setUp(() {
    mockRepository = MockWeatherRepository();
    useCase = GetCurrentWeatherByCoordUseCase(mockRepository);
  });

  group('GetCurrentWeatherByCoordUseCase', () {
    test('returns WeatherEntity from repository on success', () async {
      when(() => mockRepository.getCurrentWeatherByCoord(lat: 1.0, lon: 2.0, lang: 'en'))
          .thenAnswer((_) async => tWeather);

      final result = await useCase.execute(lat: 1.0, lon: 2.0, lang: 'en');

      expect(result, tWeather);
      verify(() => mockRepository.getCurrentWeatherByCoord(lat: 1.0, lon: 2.0, lang: 'en')).called(1);
    });

    test('passes forceRefresh to repository', () async {
      when(() => mockRepository.getCurrentWeatherByCoord(
            lat: 1.0,
            lon: 2.0,
            lang: 'en',
            forceRefresh: true,
          )).thenAnswer((_) async => tWeather);

      await useCase.execute(lat: 1.0, lon: 2.0, lang: 'en', forceRefresh: true);

      verify(() => mockRepository.getCurrentWeatherByCoord(
            lat: 1.0,
            lon: 2.0,
            lang: 'en',
            forceRefresh: true,
          )).called(1);
    });

    test('rethrows repository exceptions', () async {
      when(() => mockRepository.getCurrentWeatherByCoord(lat: 1.0, lon: 2.0, lang: 'en'))
          .thenThrow(Exception('Error'));

      expect(
        () => useCase.execute(lat: 1.0, lon: 2.0, lang: 'en'),
        throwsA(isA<Exception>()),
      );
    });
  });
}

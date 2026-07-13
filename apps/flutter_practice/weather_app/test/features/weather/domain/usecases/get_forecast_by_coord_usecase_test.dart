import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/get_forecast_by_coord_usecase.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late GetForecastByCoordUseCase useCase;
  late MockWeatherRepository mockRepository;

  final tForecast = ForecastEntity(cityName: 'London', items: []);

  setUp(() {
    mockRepository = MockWeatherRepository();
    useCase = GetForecastByCoordUseCase(mockRepository);
  });

  group('GetForecastByCoordUseCase', () {
    test('returns ForecastEntity from repository on success', () async {
      when(() => mockRepository.getForecastByCoord(lat: 1.0, lon: 2.0, lang: 'en'))
          .thenAnswer((_) async => tForecast);

      final result = await useCase.execute(lat: 1.0, lon: 2.0, lang: 'en');

      expect(result, tForecast);
      verify(() => mockRepository.getForecastByCoord(lat: 1.0, lon: 2.0, lang: 'en')).called(1);
    });

    test('passes forceRefresh to repository', () async {
      when(() => mockRepository.getForecastByCoord(
            lat: 1.0,
            lon: 2.0,
            lang: 'en',
            forceRefresh: true,
          )).thenAnswer((_) async => tForecast);

      await useCase.execute(lat: 1.0, lon: 2.0, lang: 'en', forceRefresh: true);

      verify(() => mockRepository.getForecastByCoord(
            lat: 1.0,
            lon: 2.0,
            lang: 'en',
            forceRefresh: true,
          )).called(1);
    });

    test('rethrows repository exceptions', () async {
      when(() => mockRepository.getForecastByCoord(lat: 1.0, lon: 2.0, lang: 'en'))
          .thenThrow(Exception('Error'));

      expect(
        () => useCase.execute(lat: 1.0, lon: 2.0, lang: 'en'),
        throwsA(isA<Exception>()),
      );
    });
  });
}

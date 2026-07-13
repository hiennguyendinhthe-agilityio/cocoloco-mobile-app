import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/get_forecast_usecase.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late GetForecastUseCase useCase;
  late MockWeatherRepository mockRepository;

  final tForecast = ForecastEntity(cityName: 'London', items: []);

  setUp(() {
    mockRepository = MockWeatherRepository();
    useCase = GetForecastUseCase(mockRepository);
  });

  group('GetForecastUseCase', () {
    test('returns ForecastEntity from repository on success', () async {
      when(() => mockRepository.getForecast(city: 'London', lang: 'en'))
          .thenAnswer((_) async => tForecast);

      final result = await useCase.execute(city: 'London', lang: 'en');

      expect(result, tForecast);
      verify(() => mockRepository.getForecast(city: 'London', lang: 'en')).called(1);
    });

    test('passes forceRefresh to repository', () async {
      when(() => mockRepository.getForecast(city: 'London', lang: 'en', forceRefresh: true))
          .thenAnswer((_) async => tForecast);

      await useCase.execute(city: 'London', lang: 'en', forceRefresh: true);

      verify(() => mockRepository.getForecast(city: 'London', lang: 'en', forceRefresh: true))
          .called(1);
    });

    test('throws ArgumentError when city is empty', () {
      expect(
        () => useCase.execute(city: '   ', lang: 'en'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rethrows repository exceptions', () async {
      when(() => mockRepository.getForecast(city: 'London', lang: 'en'))
          .thenThrow(Exception('Error'));

      expect(
        () => useCase.execute(city: 'London', lang: 'en'),
        throwsA(isA<Exception>()),
      );
    });
  });
}

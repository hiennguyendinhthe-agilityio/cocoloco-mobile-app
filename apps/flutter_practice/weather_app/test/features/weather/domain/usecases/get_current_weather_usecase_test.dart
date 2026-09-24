import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/weather/domain/usecases/get_current_weather_usecase.dart';

import '../../../../fixtures/weather.stub.dart';
import '../../../../repository.mocks.dart';

void main() {
  late GetCurrentWeatherUseCase usecase;
  late MockWeatherRepository mockWeatherRepository;

  const kCity = 'London';
  const kLang = 'en';

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    usecase = GetCurrentWeatherUseCase(mockWeatherRepository);
  });

  group('GetCurrentWeatherUseCase - execute:', () {
    test('returns weather from repository', () async {
      // Arrange
      when(
        () => mockWeatherRepository.getCurrentWeather(city: kCity, lang: kLang),
      ).thenAnswer((_) async => WeatherStub.london);

      // Act
      final result = await usecase.execute(city: kCity, lang: kLang);

      // Assert
      expect(result, WeatherStub.london);
      verify(
        () => mockWeatherRepository.getCurrentWeather(city: kCity, lang: kLang),
      ).called(1);
      verifyNoMoreInteractions(mockWeatherRepository);
    });

    test('propagates exceptions from repository', () {
      // Arrange
      when(
        () => mockWeatherRepository.getCurrentWeather(city: kCity, lang: kLang),
      ).thenThrow(Exception('Network Error'));

      // Assert
      expect(
        () => usecase.execute(city: kCity, lang: kLang),
        throwsA(isA<Exception>()),
      );
    });

    test('passes forceRefresh=true to repository', () async {
      when(
        () => mockWeatherRepository.getCurrentWeather(
          city: kCity,
          lang: kLang,
          forceRefresh: true,
        ),
      ).thenAnswer((_) async => WeatherStub.london);

      final result = await usecase.execute(
        city: kCity,
        lang: kLang,
        forceRefresh: true,
      );

      expect(result, WeatherStub.london);
      verify(
        () => mockWeatherRepository.getCurrentWeather(
          city: kCity,
          lang: kLang,
          forceRefresh: true,
        ),
      ).called(1);
    });
  });

  group('GetCurrentWeatherUseCase - ArgumentError cases:', () {
    test('throws ArgumentError when city is empty string', () {
      expect(
        () => usecase.execute(city: '', lang: kLang),
        throwsA(isA<ArgumentError>()),
      );
      verifyNever(
        () => mockWeatherRepository.getCurrentWeather(
          city: any(named: 'city'),
          lang: any(named: 'lang'),
        ),
      );
    });

    test('throws ArgumentError when city is only whitespace', () {
      expect(
        () => usecase.execute(city: '   ', lang: kLang),
        throwsA(isA<ArgumentError>()),
      );
      verifyNever(
        () => mockWeatherRepository.getCurrentWeather(
          city: any(named: 'city'),
          lang: any(named: 'lang'),
        ),
      );
    });
  });
}

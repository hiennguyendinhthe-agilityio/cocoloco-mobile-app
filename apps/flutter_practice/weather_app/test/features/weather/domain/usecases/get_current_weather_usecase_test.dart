import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/get_current_weather_usecase.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late GetCurrentWeatherUseCase usecase;
  late MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    usecase = GetCurrentWeatherUseCase(mockWeatherRepository);
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

  const tCity = 'London';
  const tLang = 'en';

  test('should get current weather for the city from the repository', () async {
    // Arrange
    when(() => mockWeatherRepository.getCurrentWeather(city: tCity, lang: tLang))
        .thenAnswer((_) async => tWeather);

    // Act
    final result = await usecase.execute(city: tCity, lang: tLang);

    // Assert
    expect(result, tWeather);
    verify(() => mockWeatherRepository.getCurrentWeather(city: tCity, lang: tLang)).called(1);
    verifyNoMoreInteractions(mockWeatherRepository);
  });

  test('should propagate exceptions from repository', () async {
    // Arrange
    when(() => mockWeatherRepository.getCurrentWeather(city: tCity, lang: tLang))
        .thenThrow(Exception('Network Error'));

    // Act
    final call = usecase.execute;

    // Assert
    expect(() => call(city: tCity, lang: tLang), throwsA(isA<Exception>()));
    verify(() => mockWeatherRepository.getCurrentWeather(city: tCity, lang: tLang)).called(1);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/weather/domain/entities/location_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/search_location_usecase.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late SearchLocationUseCase useCase;
  late MockWeatherRepository mockRepository;

  final tLocation = LocationEntity(
    name: 'London',
    lat: 51.5074,
    lon: -0.1278,
    country: 'GB',
  );

  setUp(() {
    mockRepository = MockWeatherRepository();
    useCase = SearchLocationUseCase(mockRepository);
  });

  group('SearchLocationUseCase', () {
    test('returns List<LocationEntity> from repository on success', () async {
      when(() => mockRepository.searchLocation('London'))
          .thenAnswer((_) async => [tLocation]);

      final result = await useCase.execute('London');

      expect(result, [tLocation]);
      verify(() => mockRepository.searchLocation('London')).called(1);
    });

    test('throws ArgumentError when query is empty', () {
      expect(
        () => useCase.execute('   '),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rethrows repository exceptions', () async {
      when(() => mockRepository.searchLocation('London'))
          .thenThrow(Exception('Error'));

      expect(
        () => useCase.execute('London'),
        throwsA(isA<Exception>()),
      );
    });
  });
}

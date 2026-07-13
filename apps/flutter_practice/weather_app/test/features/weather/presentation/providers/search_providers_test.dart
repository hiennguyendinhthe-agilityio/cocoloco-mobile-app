import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/weather/data/repositories/recent_searches_repository.dart';
import 'package:weather_app/features/weather/domain/entities/location_entity.dart';
import 'package:weather_app/features/weather/domain/usecases/search_location_usecase.dart';
import 'package:weather_app/features/weather/presentation/providers/search_providers.dart';

class MockSearchLocationUseCase extends Mock implements SearchLocationUseCase {}
class MockRecentSearchesRepository extends Mock implements RecentSearchesRepository {}

void main() {
  late MockSearchLocationUseCase mockSearchUseCase;
  late MockRecentSearchesRepository mockRecentRepo;

  final tLocation = LocationEntity(
    name: 'London',
    lat: 51.5074,
    lon: -0.1278,
    country: 'GB',
    state: 'England',
  );

  setUpAll(() {
    registerFallbackValue(tLocation);
  });

  setUp(() {
    mockSearchUseCase = MockSearchLocationUseCase();
    mockRecentRepo = MockRecentSearchesRepository();
  });

  ProviderContainer makeContainer() => ProviderContainer(
        overrides: [
          searchLocationUseCaseProvider.overrideWithValue(mockSearchUseCase),
          recentSearchesRepositoryProvider.overrideWithValue(mockRecentRepo),
        ],
      );

  group('searchQueryProvider', () {
    test('initial value is empty string', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      expect(container.read(searchQueryProvider), '');
    });

    test('can be updated', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      container.read(searchQueryProvider.notifier).state = 'London';
      expect(container.read(searchQueryProvider), 'London');
    });
  });

  group('RecentSearchesNotifier', () {
    test('initial build loads from repository', () async {
      when(() => mockRecentRepo.getRecentSearches()).thenAnswer((_) async => [tLocation]);

      final container = makeContainer();
      addTearDown(container.dispose);

      final result = await container.read(recentSearchesProvider.future);
      expect(result, [tLocation]);
      verify(() => mockRecentRepo.getRecentSearches()).called(1);
    });

    test('addRecentSearch calls repo and refreshes state', () async {
      when(() => mockRecentRepo.getRecentSearches()).thenAnswer((_) async => []);
      when(() => mockRecentRepo.addRecentSearch(tLocation)).thenAnswer((_) async {});

      final container = makeContainer();
      addTearDown(container.dispose);

      // Wait for initial build
      await container.read(recentSearchesProvider.future);

      // Set up mock for after add
      when(() => mockRecentRepo.getRecentSearches()).thenAnswer((_) async => [tLocation]);

      await container.read(recentSearchesProvider.notifier).addRecentSearch(tLocation);

      final result = container.read(recentSearchesProvider).value;
      expect(result, [tLocation]);
      verify(() => mockRecentRepo.addRecentSearch(tLocation)).called(1);
    });

    test('removeRecentSearch calls repo and refreshes state', () async {
      when(() => mockRecentRepo.getRecentSearches()).thenAnswer((_) async => [tLocation]);
      when(() => mockRecentRepo.removeRecentSearch(tLocation)).thenAnswer((_) async {});

      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(recentSearchesProvider.future);

      when(() => mockRecentRepo.getRecentSearches()).thenAnswer((_) async => []);

      await container.read(recentSearchesProvider.notifier).removeRecentSearch(tLocation);

      final result = container.read(recentSearchesProvider).value;
      expect(result, isEmpty);
      verify(() => mockRecentRepo.removeRecentSearch(tLocation)).called(1);
    });

    test('clearRecentSearches sets state to empty list', () async {
      when(() => mockRecentRepo.getRecentSearches()).thenAnswer((_) async => [tLocation]);
      when(() => mockRecentRepo.clearRecentSearches()).thenAnswer((_) async {});

      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(recentSearchesProvider.future);
      await container.read(recentSearchesProvider.notifier).clearRecentSearches();

      final result = container.read(recentSearchesProvider).value;
      expect(result, isEmpty);
      verify(() => mockRecentRepo.clearRecentSearches()).called(1);
    });
  });
}

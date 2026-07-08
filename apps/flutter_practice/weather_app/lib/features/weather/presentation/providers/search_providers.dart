import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/features/weather/data/repositories/recent_searches_repository.dart';
import 'package:weather_app/features/weather/domain/entities/location_entity.dart';
import 'package:weather_app/features/weather/domain/usecases/search_location_usecase.dart';

// 1. The raw search query typed by the user
final searchQueryProvider = StateProvider<String>((ref) => '');

// 2. Search Results based on the Query with built-in Riverpod debouncing
final searchResultsProvider = FutureProvider.autoDispose<List<LocationEntity>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  
  if (query.trim().isEmpty) {
    return [];
  }

  // Debounce logic natively in Riverpod
  var isCancelled = false;
  ref.onDispose(() => isCancelled = true);
  
  // Wait for 500ms before actually hitting the API
  await Future.delayed(const Duration(milliseconds: 500));
  
  // If the user typed something else during the 500ms, this provider is disposed
  // and we abort the network request.
  if (isCancelled) {
    throw Exception('Aborted for debounce');
  }

  final useCase = ref.watch(searchLocationUseCaseProvider);
  return await useCase.execute(query);
});

// 3. Recent Searches Provider using AsyncNotifier (Riverpod 3.0 standard)
class RecentSearchesNotifier extends AsyncNotifier<List<LocationEntity>> {
  @override
  FutureOr<List<LocationEntity>> build() async {
    return _repository.getRecentSearches();
  }

  RecentSearchesRepository get _repository => ref.read(recentSearchesRepositoryProvider);

  Future<void> addRecentSearch(LocationEntity location) async {
    state = const AsyncValue.loading();
    await _repository.addRecentSearch(location);
    state = await AsyncValue.guard(() => _repository.getRecentSearches());
  }

  Future<void> removeRecentSearch(LocationEntity location) async {
    state = const AsyncValue.loading();
    await _repository.removeRecentSearch(location);
    state = await AsyncValue.guard(() => _repository.getRecentSearches());
  }

  Future<void> clearRecentSearches() async {
    state = const AsyncValue.loading();
    await _repository.clearRecentSearches();
    state = const AsyncValue.data([]);
  }
}

final recentSearchesProvider = AsyncNotifierProvider<RecentSearchesNotifier, List<LocationEntity>>(
  RecentSearchesNotifier.new,
);

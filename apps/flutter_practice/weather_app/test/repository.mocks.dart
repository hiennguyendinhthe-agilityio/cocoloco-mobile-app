import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/core/storage/preferences_service.dart';
import 'package:weather_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:weather_app/features/weather/domain/repositories/recent_searches_repository.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

// ---------------------------------------------------------------------------
// Weather Repository Mocks
// ---------------------------------------------------------------------------

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockRecentSearchesRepository extends Mock
    implements RecentSearchesRepository {}

// ---------------------------------------------------------------------------
// Settings Repository Mocks
// ---------------------------------------------------------------------------

class MockSettingsRepository extends Mock implements SettingsRepository {}

// ---------------------------------------------------------------------------
// Storage Mocks
// ---------------------------------------------------------------------------

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockPreferencesService extends Mock implements PreferencesService {}

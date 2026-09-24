import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/weather/data/datasources/weather_local_datasource.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:weather_app/features/settings/data/datasources/settings_local_data_source.dart';

// ---------------------------------------------------------------------------
// Weather Datasource Mocks
// ---------------------------------------------------------------------------

class MockWeatherRemoteDatasource extends Mock
    implements WeatherRemoteDatasource {}

class MockWeatherLocalDatasource extends Mock
    implements WeatherLocalDatasource {}

// ---------------------------------------------------------------------------
// Settings Datasource Mocks
// ---------------------------------------------------------------------------

class MockSettingsLocalDataSource extends Mock
    implements SettingsLocalDataSource {}

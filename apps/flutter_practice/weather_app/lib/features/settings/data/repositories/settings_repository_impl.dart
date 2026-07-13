import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:weather_app/features/settings/domain/entities/app_settings.dart';
import 'package:weather_app/features/settings/domain/repositories/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(ref.watch(settingsLocalDataSourceProvider));
});

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _localDataSource;

  SettingsRepositoryImpl(this._localDataSource);

  @override
  Future<AppSettings> getSettings() {
    return _localDataSource.getSettings();
  }

  @override
  Future<void> saveSettings(AppSettings settings) {
    return _localDataSource.saveSettings(settings);
  }
}

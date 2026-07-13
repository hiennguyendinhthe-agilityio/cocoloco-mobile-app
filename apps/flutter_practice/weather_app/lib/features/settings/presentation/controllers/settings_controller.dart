import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:weather_app/features/settings/domain/entities/app_settings.dart';

final settingsControllerProvider =
    AsyncNotifierProvider<SettingsController, AppSettings>(
  () => SettingsController(),
);

class SettingsController extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() async {
    final repository = ref.watch(settingsRepositoryProvider);
    return repository.getSettings();
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    if (state.value == null) return;
    final newSettings = state.value!.copyWith(themeMode: mode);
    await _saveSettings(newSettings);
  }

  Future<void> updateTemperatureUnit(TemperatureUnit unit) async {
    if (state.value == null) return;
    final newSettings = state.value!.copyWith(temperatureUnit: unit);
    await _saveSettings(newSettings);
  }

  Future<void> updateLocale(Locale locale) async {
    if (state.value == null) return;
    final newSettings = state.value!.copyWith(locale: locale);
    await _saveSettings(newSettings);
  }

  Future<void> _saveSettings(AppSettings newSettings) async {
    // Optimistic update
    state = AsyncData(newSettings);
    try {
      final repository = ref.read(settingsRepositoryProvider);
      await repository.saveSettings(newSettings);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

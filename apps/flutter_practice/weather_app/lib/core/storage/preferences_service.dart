import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  return PreferencesService(ref.watch(sharedPreferencesProvider));
});

class PreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  static const _languageKey = 'language_code';
  static const _themeKey = 'theme_mode';

  // --- Language ---
  String? getLanguageCode() {
    return _prefs.getString(_languageKey);
  }

  Future<void> saveLanguageCode(String code) async {
    await _prefs.setString(_languageKey, code);
  }

  // --- Theme ---
  String? getThemeMode() {
    return _prefs.getString(_themeKey);
  }

  Future<void> saveThemeMode(String mode) async {
    await _prefs.setString(_themeKey, mode);
  }
}

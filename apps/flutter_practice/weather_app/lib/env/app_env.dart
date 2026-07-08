// App environment constants.
//
// ⚠️  SECURITY: Add this file to .gitignore before pushing to any repo.
//     Pattern: lib/env/app_env.dart
//
// This file is the single source of truth for:
//   - API keys
//   - Base URLs
//   - Feature flags per environment

import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class AppEnv {
  AppEnv._();

  // ── OpenWeatherMap ─────────────────────────────────────────────────────────

  /// API key from https://openweathermap.org/api
  static String get owmApiKey => dotenv.env['OWM_API_KEY'] ?? '';

  /// Base URL — current weather + forecast
  static const String owmBaseUrl = 'https://api.openweathermap.org/data/2.5';

  /// Base URL — geocoding / city search
  static const String owmGeoBaseUrl = 'https://api.openweathermap.org/geo/1.0';

  // ── Defaults ───────────────────────────────────────────────────────────────

  /// Unit system: metric (°C), imperial (°F), standard (K)
  static const String defaultUnits = 'metric';

  /// Response language
  static const String defaultLang = 'en';
}

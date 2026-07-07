// Layer 3: Theme State — Riverpod Notifier.
//
// Manages [ThemeMode] as app-level state.
// Exposes a simple toggle API. Persists nothing in this iteration
// (persistence can be added later without changing the public API).
//
// Rules:
//   - State type: [ThemeMode] (Flutter-native, no custom wrapper needed).
//   - Default: [ThemeMode.system] — respects user's OS preference.
//   - Provider is annotated so code-gen can run if needed in future.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/core/storage/preferences_service.dart';

/// Notifier that owns and mutates the app's [ThemeMode].
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final prefs = ref.watch(preferencesServiceProvider);
    final savedMode = prefs.getThemeMode();
    if (savedMode == 'light') return ThemeMode.light;
    if (savedMode == 'dark') return ThemeMode.dark;
    return ThemeMode.system; // Default: follow OS
  }

  /// Cycle through: system → light → dark → system.
  void cycle() {
    final nextMode = switch (state) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    setMode(nextMode);
  }

  /// Set an explicit [ThemeMode].
  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    final prefs = ref.read(preferencesServiceProvider);
    final modeStr = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await prefs.saveThemeMode(modeStr);
  }

  /// Toggle between light and dark (ignores system).
  void toggleLightDark() {
    final nextMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    setMode(nextMode);
  }
}

/// Global provider — use [ref.watch(themeModeProvider)] in widgets,
/// [ref.read(themeModeProvider.notifier)] to mutate.
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

// App root widget.
//
// Responsibilities:
//   - Wire [GoRouter] from [appRouterProvider].
//   - Wire [ThemeMode] from [themeModeProvider].
//   - Wire [ThemeData] from [AppTheme].
//   - Hand off to [MaterialApp.router]. No business logic here.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/core/localization/locale_provider.dart';
import 'package:weather_app/router/app_router.dart';
import 'package:weather_app/theme/app_theme.dart';
import 'package:weather_app/theme/providers/theme_provider.dart';
import 'package:weather_app/l10n/app_localizations.dart';

import 'package:device_preview/device_preview.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder, // Connect DevicePreview
      // ── Localization ───────────────────────────────────────────────────────
      locale: locale, // Always use our app's locale from Settings
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // ── Theme ──────────────────────────────────────────────────────────────
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      // ── Router ─────────────────────────────────────────────────────────────
      routerConfig: router,
    );
  }
}

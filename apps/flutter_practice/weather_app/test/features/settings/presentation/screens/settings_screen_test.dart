import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/settings/domain/entities/app_settings.dart';
import 'package:weather_app/features/settings/presentation/controllers/settings_controller.dart';
import 'package:weather_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:weather_app/l10n/app_localizations.dart';

// Since SettingsScreen uses context.l10n, we need to wrap it in a MaterialApp with localizations
Widget createWidgetUnderTest(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('vi')],
      home: const SettingsScreen(),
    ),
  );
}

void main() {
  testWidgets(
    'SettingsScreen should display Theme, Unit, and Language sections',
    (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          settingsControllerProvider.overrideWith(
            () => MockSettingsController(),
          ),
        ],
      );

      await tester.pumpWidget(createWidgetUnderTest(container));
      await tester.pumpAndSettle(); // Wait for Future/AsyncNotifier to settle

      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('Temperature Unit'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('System Default'), findsOneWidget);
      expect(find.text('Celsius (°C)'), findsOneWidget);
      expect(find.text('Tiếng Việt'), findsOneWidget);
    },
  );
}

class MockSettingsController extends AsyncNotifier<AppSettings>
    implements SettingsController {
  @override
  Future<AppSettings> build() async {
    return const AppSettings(
      themeMode: ThemeMode.system,
      temperatureUnit: TemperatureUnit.celsius,
      locale: Locale('vi'),
    );
  }

  @override
  Future<void> updateLocale(Locale locale) async {}

  @override
  Future<void> updateTemperatureUnit(TemperatureUnit unit) async {}

  @override
  Future<void> updateThemeMode(ThemeMode mode) async {}
}

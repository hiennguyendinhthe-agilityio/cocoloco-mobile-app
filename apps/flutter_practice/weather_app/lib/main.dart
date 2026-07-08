// Entry point.
//
// Responsibilities:
//   - Bootstrap Flutter bindings.
//   - Wrap app in [ProviderScope] (Riverpod requirement).
//   - Hand off to [App] widget.
//   - NO business logic, NO initialization side-effects here.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/app.dart';
import 'package:weather_app/core/storage/preferences_service.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");

  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(
    DevicePreview(
      enabled: true, // You can toggle this based on debug mode if you want
      builder: (context) => ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        ],
        child: const App(),
      ),
    ),
  );
}

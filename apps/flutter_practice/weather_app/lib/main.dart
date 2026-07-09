// Entry point.
//
// Responsibilities:
//   - Bootstrap Flutter bindings.
//   - Wrap app in [ProviderScope] (Riverpod requirement).
//   - Hand off to [App] widget.
//   - NO business logic, NO initialization side-effects here.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/app.dart';
import 'package:weather_app/core/storage/preferences_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';
import 'package:weather_app/core/services/push_notification_service.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:device_preview/device_preview.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('weather_cache');
  await Hive.openBox('forecast_cache');

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Initialize Push Notifications
  await PushNotificationService.instance.initialize();

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

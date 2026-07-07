// Router configuration.
//
// Assembles [GoRouter] from [AppRoutes] constants.
// Injected into [MaterialApp.router] via Riverpod provider.
//
// Rules:
//   - NO hardcoded path strings. All paths come from [AppRoutes].
//   - NO business logic. Route guards (redirects) go here when needed.
//   - Provider is kept at file scope for easy access via ref.watch / ref.read.

// Removed material import
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/router/routes.dart';

import 'package:weather_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:weather_app/features/weather/presentation/screens/home_screen.dart';
import 'package:weather_app/features/weather/presentation/screens/splash_screen.dart';

// ---------------------------------------------------------------------------
// GoRouter instance
// ---------------------------------------------------------------------------

final _router = GoRouter(
  initialLocation: AppRoutes.splashPath,
  debugLogDiagnostics: false, // set true during development if needed
  routes: [
    GoRoute(
      path: AppRoutes.splashPath,
      name: AppRoutes.splashName,
      builder: (_, _) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.homePath,
      name: AppRoutes.homeName,
      builder: (_, _) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.settingsPath,
      name: AppRoutes.settingsName,
      builder: (_, _) => const SettingsScreen(),
    ),
  ],
);

// ---------------------------------------------------------------------------
// Provider — exposes [GoRouter] to the widget tree via Riverpod.
// ---------------------------------------------------------------------------

/// Read-only provider. [GoRouter] is stateful internally; we expose it
/// as a plain provider (not NotifierProvider) because GoRouter owns its state.
final appRouterProvider = Provider<GoRouter>((ref) => _router);

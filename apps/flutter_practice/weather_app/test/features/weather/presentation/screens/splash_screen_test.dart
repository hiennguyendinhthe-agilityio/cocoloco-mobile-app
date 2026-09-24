import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/features/weather/presentation/screens/splash_screen.dart';
import 'package:weather_app/l10n/app_localizations.dart';

void main() {
  testWidgets('SplashScreen rendering and navigation', (tester) async {
    // We cannot easily test go_router context.go inside pumpWidget without setting up a real GoRouter.
    // So we'll set up a mock GoRouter using a minimal GoRoute to verify navigation happens.
    var didNavigateToHome = false;

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
        GoRoute(
          path: '/home',
          builder: (context, state) {
            didNavigateToHome = true;
            return const Scaffold(body: Text('Home'));
          },
        ),
      ],
    );

    final app = MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('vi')],
    );

    await tester.pumpWidget(app);

    // Initial render
    expect(find.byIcon(Icons.wb_sunny), findsOneWidget);

    // Fast forward animation & delay
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify it navigated to home
    expect(didNavigateToHome, isTrue);
    expect(find.text('Home'), findsOneWidget);
  });
}

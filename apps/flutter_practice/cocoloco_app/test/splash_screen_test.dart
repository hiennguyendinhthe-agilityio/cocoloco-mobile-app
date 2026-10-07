import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cocoloco_app/screens/splash_screen.dart';

void main() {
  group('SplashScreen Tests', () {
    testWidgets('Renders brand elements properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SplashScreen(
              duration: Duration(milliseconds: 1000),
            ),
          ),
        ),
      );

      // Initial pump
      await tester.pump();

      // Verify brand text elements exist in the widget tree
      expect(find.text('COCOLOCO'), findsOneWidget);
      expect(find.text('ARTISANAL COFFEE & BAKERY'), findsOneWidget);
      expect(find.text('Crafted with Passion • AgilityIO'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Advance through animation and navigation
      await tester.pump(const Duration(milliseconds: 1200));
      await tester.pumpAndSettle();
    });

    testWidgets('Navigates to target screen after duration completes', (WidgetTester tester) async {
      const testKey = Key('target_screen_landing');

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SplashScreen(
              duration: Duration(milliseconds: 500),
              targetScreen: Scaffold(
                key: testKey,
                body: Text('Welcome to Cocoloco Store'),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('COCOLOCO'), findsOneWidget);
      expect(find.byKey(testKey), findsNothing);

      // Advance timer past duration and allow fade transition to settle
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      // Should now be on target screen
      expect(find.byKey(testKey), findsOneWidget);
      expect(find.text('Welcome to Cocoloco Store'), findsOneWidget);
    });
  });
}

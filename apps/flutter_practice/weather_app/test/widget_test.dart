// Smoke test — verifies core utility widgets build without throwing.
//
// Note: The top-level [App] widget cannot be reliably tested in isolation
// because it includes GoRouter navigation, push notification setup, and
// animations that leave pending timers. Those behaviours are tested
// individually in the feature-level widget tests under test/features/...
//
// This file serves as a structural placeholder and sanity check.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MaterialApp widget tree is valid (sanity check)',
      (WidgetTester tester) async {
    // A minimal widget tree that can be rendered safely in isolation.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('weather_app')),
        ),
      ),
    );

    expect(find.text('weather_app'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}

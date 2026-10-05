import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:blog_app/core/localization/app_localizations.dart';
import 'package:blog_app/screens/order_success_screen.dart';

void main() {
  Widget createTestWidget({VoidCallback? onDone}) {
    return MaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: OrderSuccessScreen(onDone: onDone),
      ),
    );
  }

  group('OrderSuccessScreen Widget Tests', () {
    testWidgets('renders hero image, title, subtitle, and action button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Ordered!'), findsOneWidget);
      expect(find.text('Everything will be ready in 3 minutes.'), findsOneWidget);
      expect(find.text('Okay, got it!'), findsOneWidget);
    });

    testWidgets('pressing Okay button invokes onDone callback', (tester) async {
      var callbackCalled = false;
      await tester.pumpWidget(createTestWidget(onDone: () {
        callbackCalled = true;
      }));
      await tester.pumpAndSettle();

      final button = find.text('Okay, got it!');
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(callbackCalled, isTrue);
    });
  });
}

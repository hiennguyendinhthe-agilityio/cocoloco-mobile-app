import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:blog_app/core/localization/app_localizations.dart';
import 'package:blog_app/screens/profile_screen.dart';
import 'package:blog_app/screens/settings_screen.dart';

void main() {
  Widget buildTestSettingsScreen() {
    return const ProviderScope(
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: SettingsScreen(),
      ),
    );
  }

  Widget buildTestProfileScreen() {
    return const ProviderScope(
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: ProfileScreen(),
      ),
    );
  }

  group('SettingsScreen Tests', () {
    testWidgets('renders all preference options and support items', (tester) async {
      await tester.pumpWidget(buildTestSettingsScreen());
      await tester.pumpAndSettle();

      // Check title and section headers
      expect(find.text('Settings & Utilities'), findsWidgets);
      expect(find.text('Information & Support'), findsOneWidget);

      // Check preference items
      expect(find.text('Push Notifications'), findsOneWidget);
      expect(find.text('Account Security'), findsOneWidget);
      expect(find.text('Display Language'), findsOneWidget);
      expect(find.text('Theme Mode'), findsOneWidget);

      // Check support items
      expect(find.text('Customer Support Hotline'), findsOneWidget);
      expect(find.text('Terms of Service & Policies'), findsOneWidget);
      expect(find.text('App Version'), findsOneWidget);
    });

    testWidgets('tapping Account Security shows RS256 JWKS dialog', (tester) async {
      await tester.pumpWidget(buildTestSettingsScreen());
      await tester.pumpAndSettle();

      // Tap on Account Security
      await tester.tap(find.text('Account Security'));
      await tester.pumpAndSettle();

      // Verify dialog is shown
      expect(find.text('Clerk RS256 JWKS Active Guard'), findsOneWidget);
      expect(find.text('Understood'), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('Understood'));
      await tester.pumpAndSettle();

      expect(find.text('Clerk RS256 JWKS Active Guard'), findsNothing);
    });

    testWidgets('tapping Theme Mode opens theme selection modal bottom sheet', (tester) async {
      await tester.pumpWidget(buildTestSettingsScreen());
      await tester.pumpAndSettle();

      // Tap on Theme Mode
      await tester.tap(find.text('Theme Mode'));
      await tester.pumpAndSettle();

      // Verify theme options are presented inside modal sheet
      expect(find.text('Light Theme'), findsOneWidget);
      expect(find.text('Dark Theme'), findsOneWidget);
      expect(find.text('System Default'), findsWidgets);
    });
  });

  group('ProfileScreen Settings Navigation Tests', () {
    testWidgets('ProfileScreen has settings icon in AppBar and navigates to SettingsScreen', (tester) async {
      await tester.pumpWidget(buildTestProfileScreen());
      await tester.pumpAndSettle();

      // Verify settings icon in AppBar
      final settingsButton = find.byIcon(Icons.settings_outlined);
      expect(settingsButton, findsOneWidget);

      // Tap settings button
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();

      // Verify we arrived at SettingsScreen
      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(find.text('Push Notifications'), findsOneWidget);
    });
  });
}

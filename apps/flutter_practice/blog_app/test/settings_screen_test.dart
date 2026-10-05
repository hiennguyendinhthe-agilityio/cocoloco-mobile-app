import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:blog_app/core/localization/app_localizations.dart';
import 'package:blog_app/core/localization/locale_provider.dart';
import 'package:blog_app/core/services/session_service.dart';
import 'package:blog_app/models/user_profile.dart';
import 'package:blog_app/screens/profile_screen.dart';
import 'package:blog_app/screens/settings_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() async {
    await SessionService.instance.logout();
  });
  Widget buildTestSettingsScreen() {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, _) {
          final locale = ref.watch(localeProvider);
          return MaterialApp(
            locale: locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SettingsScreen(),
          );
        },
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

    testWidgets('toggling push notifications switch updates state', (tester) async {
      await tester.pumpWidget(buildTestSettingsScreen());
      await tester.pumpAndSettle();

      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);
      expect(tester.widget<Switch>(switchFinder).value, isTrue);

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();
      expect(tester.widget<Switch>(switchFinder).value, isFalse);

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();
      expect(tester.widget<Switch>(switchFinder).value, isTrue);
    });

    testWidgets('tapping Display Language allows selecting Vietnamese and English', (tester) async {
      await tester.pumpWidget(buildTestSettingsScreen());
      await tester.pumpAndSettle();

      // Tap Display Language
      await tester.tap(find.text('Display Language'));
      await tester.pumpAndSettle();

      expect(find.text('Select Language'), findsOneWidget);
      expect(find.text('Vietnamese (Tiếng Việt)'), findsOneWidget);

      // Select Vietnamese
      await tester.tap(find.text('Vietnamese (Tiếng Việt)'));
      await tester.pumpAndSettle();

      // Modal closed, screen now displays Vietnamese text
      expect(find.text('Select Language'), findsNothing);
      expect(find.text('Cài đặt & Tiện ích'), findsWidgets);

      // Tap Display Language again in Vietnamese
      await tester.tap(find.text('Ngôn ngữ hiển thị'));
      await tester.pumpAndSettle();

      // Switch back to English
      await tester.tap(find.text('English (Tiếng Anh)'));
      await tester.pumpAndSettle();

      expect(find.text('Settings & Utilities'), findsWidgets);
    });

    testWidgets('tapping Theme Mode allows changing theme modes', (tester) async {
      await tester.pumpWidget(buildTestSettingsScreen());
      await tester.pumpAndSettle();

      // Tap on Theme Mode
      await tester.tap(find.text('Theme Mode'));
      await tester.pumpAndSettle();

      // Verify theme options are presented inside modal sheet
      expect(find.text('Light Theme'), findsOneWidget);
      expect(find.text('Dark Theme'), findsOneWidget);
      expect(find.text('System Default'), findsWidgets);

      // Tap Dark Theme
      await tester.tap(find.text('Dark Theme'));
      await tester.pumpAndSettle();

      // Modal closed, Dark indicator is shown
      expect(find.text('Light Theme'), findsNothing);
      expect(find.text('🌙 Dark'), findsOneWidget);

      // Re-open and select Light Theme
      await tester.tap(find.text('Theme Mode'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Light Theme'));
      await tester.pumpAndSettle();

      expect(find.text('☀️ Light'), findsOneWidget);
    });

    testWidgets('tapping support hotline and terms shows coming soon SnackBar', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestSettingsScreen());
      await tester.pumpAndSettle();

      // Tap Customer Support Hotline
      await tester.tap(find.text('Customer Support Hotline'));
      await tester.pump();
      expect(find.text('Call Hotline feature coming soon!'), findsOneWidget);

      // Clear SnackBar
      ScaffoldMessenger.of(tester.element(find.byType(SettingsScreen))).clearSnackBars();
      await tester.pumpAndSettle();

      // Tap Terms of Service & Policies
      await tester.tap(find.text('Terms of Service & Policies'));
      await tester.pump();
      expect(find.text('Terms of Service & Policies feature coming soon!'), findsOneWidget);
    });

    testWidgets('Logged in user sees Sign Out, can cancel or confirm logout', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await SessionService.instance.loginAs(AppRole.user);

      await tester.pumpWidget(buildTestSettingsScreen());
      await tester.pumpAndSettle();

      // Find Sign Out button
      final signOutBtn = find.widgetWithText(OutlinedButton, 'Sign Out');
      expect(signOutBtn, findsOneWidget);

      // Tap Sign Out
      await tester.tap(signOutBtn);
      await tester.pumpAndSettle();

      // Dialog opens
      expect(find.text('Are you sure you want to sign out?'), findsOneWidget);

      // Tap Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Are you sure you want to sign out?'), findsNothing);
      expect(SessionService.instance.isLoggedIn, isTrue);

      // Tap Sign Out again and confirm
      await tester.tap(signOutBtn);
      await tester.pumpAndSettle();

      final confirmBtn = find.widgetWithText(ElevatedButton, 'Sign Out');
      expect(confirmBtn, findsOneWidget);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      expect(SessionService.instance.isLoggedIn, isFalse);
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

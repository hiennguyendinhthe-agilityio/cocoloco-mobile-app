import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:blog_app/core/localization/app_localizations.dart';
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

  Widget createProfileScreen() {
    return const ProviderScope(
      child: MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: ProfileScreen(),
      ),
    );
  }

  group('ProfileScreen Widget Tests', () {
    testWidgets('Guest Mode: renders sign in prompt and guest options', (tester) async {
      await SessionService.instance.logout();

      await tester.pumpWidget(createProfileScreen());
      await tester.pumpAndSettle();

      expect(find.text('Cocoloco Account'), findsOneWidget);
      expect(find.text('Earn beans, save addresses & track orders'), findsOneWidget);
      expect(find.text('Order History'), findsOneWidget);
    });

    testWidgets('User Mode: renders member profile, rewards, and menu interactions', (tester) async {
      await SessionService.instance.loginAs(AppRole.user);

      await tester.pumpWidget(createProfileScreen());
      await tester.pumpAndSettle();

      expect(find.text('Thu Ha (Customer)'), findsOneWidget);
      expect(find.text('customer@cocoloco.vn'), findsOneWidget);
      expect(find.text('⭐ Loyal Member (USER)'), findsOneWidget);
      expect(find.text('COCOLOCO REWARDS'), findsOneWidget);

      // Tap Order History menu item
      final orderHistoryItem = find.text('Order History');
      await tester.ensureVisible(orderHistoryItem);
      await tester.pumpAndSettle();
      await tester.tap(orderHistoryItem);
      await tester.pumpAndSettle();

      expect(find.text('Order History feature coming soon!'), findsOneWidget);

      // Tap Settings icon in AppBar
      final settingsIcon = find.byIcon(Icons.settings_outlined);
      expect(settingsIcon, findsOneWidget);
      await tester.tap(settingsIcon);
      await tester.pumpAndSettle();

      // Settings screen should be pushed
      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    testWidgets('Admin Mode: renders Admin Hub banner and management options', (tester) async {
      await SessionService.instance.loginAs(AppRole.admin);

      await tester.pumpWidget(createProfileScreen());
      await tester.pumpAndSettle();

      expect(find.text('Hien Nguyen (Admin)'), findsOneWidget);
      expect(find.text('🛡️ Administrator (ADMIN)'), findsOneWidget);
      expect(find.text('STORE MANAGEMENT'), findsOneWidget);
    });
  });
}

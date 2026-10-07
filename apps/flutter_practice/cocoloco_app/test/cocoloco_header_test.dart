import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cocoloco_app/core/localization/app_localizations.dart';
import 'package:cocoloco_app/core/services/session_service.dart';
import 'package:cocoloco_app/models/user_profile.dart';
import 'package:cocoloco_app/widgets/cocoloco_header.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() async {
    await SessionService.instance.logout();
  });

  Widget createHeaderWidget({
    required VoidCallback onSearchTap,
    ThemeMode themeMode = ThemeMode.light,
  }) {
    return ProviderScope(
      child: MaterialApp(
        themeMode: themeMode,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: CocolocoHeader(onSearchTap: onSearchTap),
        ),
      ),
    );
  }

  group('CocolocoHeader Widget Tests', () {
    testWidgets('renders logo, search icon, cart icon, and guest avatar', (tester) async {
      var searchTapped = false;
      await tester.pumpWidget(createHeaderWidget(onSearchTap: () {
        searchTapped = true;
      }));
      await tester.pumpAndSettle();

      // Search button tap
      final searchIcon = find.byIcon(Icons.search_rounded);
      expect(searchIcon, findsOneWidget);
      await tester.tap(searchIcon);
      expect(searchTapped, isTrue);

      // Cart icon exists
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);

      // Guest avatar icon exists
      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
    });

    testWidgets('renders logged-in user initial when user has no avatarUrl', (tester) async {
      await SessionService.instance.loginAs(AppRole.user);

      await tester.pumpWidget(createHeaderWidget(onSearchTap: () {}));
      await tester.pumpAndSettle();

      // Initial letter 'T' from 'Thu Ha (Customer)'
      expect(find.text('T'), findsOneWidget);
    });

    testWidgets('renders correctly in dark mode', (tester) async {
      await tester.pumpWidget(createHeaderWidget(
        onSearchTap: () {},
        themeMode: ThemeMode.dark,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(CocolocoHeader), findsOneWidget);
    });
  });
}

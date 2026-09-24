import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/presentation/widgets/app_drawer.dart';
import 'package:weather_app/features/weather/presentation/widgets/drawer_nav_item.dart';
import 'package:weather_app/features/weather/presentation/widgets/drawer_profile_header.dart';
import 'package:weather_app/features/weather/presentation/widgets/premium_upgrade_card.dart';

import '../../../../test_utils.dart';

void main() {
  group('AppDrawer Widget Tests:', () {
    testWidgets('renders all expected items', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithProviders(
          TestUtils.wrapWithApp(
            Scaffold(
              key: const Key('scaffold'),
              drawer: const AppDrawer(),
              body: Container(),
            ),
          ),
          container: TestUtils.createContainer(),
        )
      );

      final scaffoldState = tester.state<ScaffoldState>(find.byKey(const Key('scaffold')));
      scaffoldState.openDrawer();
      
      // Wait for drawer animation
      await tester.pumpAndSettle();

      expect(find.byType(DrawerProfileHeader), findsOneWidget);
      expect(find.byType(PremiumUpgradeCard), findsOneWidget);
      expect(find.byType(DrawerNavItem, skipOffstage: false), findsNWidgets(7));
    });
  });
}

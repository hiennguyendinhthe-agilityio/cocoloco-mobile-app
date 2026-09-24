import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/extensions/l10n_extension.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_initial_state.dart';

import '../../../../test_utils.dart';

void main() {
  group('WeatherInitialState Widget Tests:', () {
    testWidgets('renders correctly and responds to tap', (tester) async {
      bool searchPressed = false;

      // Arrange
      await tester.pumpWidget(
        TestUtils.wrapWithApp(
          WeatherInitialState(
            onSearchPressed: () => searchPressed = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert visual elements exist
      expect(find.byIcon(Icons.wb_sunny_outlined), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget); // Top icon

      // Verify L10n strings
      final BuildContext context = tester.element(find.byType(WeatherInitialState));
      expect(find.text(context.l10n.tapToSearch), findsOneWidget);

      // Act
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle();

      // Assert
      expect(searchPressed, true);
    });
  });
}

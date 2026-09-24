import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/extensions/l10n_extension.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_error_state.dart';

import '../../../../test_utils.dart';

void main() {
  group('WeatherErrorState Widget Tests:', () {
    testWidgets('renders correctly and responds to tap', (tester) async {
      bool searchPressed = false;

      // Arrange
      await tester.pumpWidget(
        TestUtils.wrapWithApp(
          WeatherErrorState(
            error: Exception('Test error message'),
            onSearchPressed: () => searchPressed = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert visual elements exist
      expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget); // Top icon
      expect(find.byIcon(Icons.search), findsOneWidget); // Button icon

      // Verify the user-friendly error logic
      expect(find.text('Test error message'), findsOneWidget);

      // Verify L10n strings
      final BuildContext context = tester.element(find.byType(WeatherErrorState));
      expect(find.text(context.l10n.tryAnotherSearch), findsOneWidget);
      expect(find.text(context.l10n.searchCityBtn), findsOneWidget);

      // Act
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle();

      // Assert
      expect(searchPressed, true);
    });

    testWidgets('handles network errors specifically', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithApp(
          WeatherErrorState(
            error: Exception('SocketException: Failed to connect'),
            onSearchPressed: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(WeatherErrorState));
      expect(find.text(context.l10n.noInternetConnection), findsOneWidget);
    });
  });
}

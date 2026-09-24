import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/presentation/widgets/glass_card.dart';

import '../../../../test_utils.dart';

void main() {
  group('GlassCard Widget Tests:', () {
    testWidgets('renders child correctly', (tester) async {
      // Arrange
      await tester.pumpWidget(
        TestUtils.wrapWithApp(
          const GlassCard(
            child: Text('Test Content'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert visual elements exist
      expect(find.text('Test Content'), findsOneWidget);
    });
  });
}

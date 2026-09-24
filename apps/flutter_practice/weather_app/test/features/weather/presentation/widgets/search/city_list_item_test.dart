import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/presentation/widgets/search/city_list_item.dart';

import '../../../../../test_utils.dart';

void main() {
  group('CityListItem Widget Tests:', () {
    testWidgets('renders all details correctly', (tester) async {
      bool tapped = false;
      bool deleted = false;

      await tester.pumpWidget(
        TestUtils.wrapWithApp(
          CityListItem(
            city: 'London',
            country: 'GB',
            temperature: '20°',
            weatherIcon: Icons.cloud,
            leadingIcon: Icons.history,
            onTap: () => tapped = true,
            onDelete: () => deleted = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert basic renders
      expect(find.text('London'), findsOneWidget);
      expect(find.text('GB'), findsOneWidget);
      expect(find.text('20°'), findsOneWidget);
      expect(find.byIcon(Icons.cloud), findsOneWidget);
      expect(find.byIcon(Icons.history), findsOneWidget);
      expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);

      // Act: tap list item
      await tester.tap(find.text('London'));
      await tester.pumpAndSettle();
      expect(tapped, true);

      // Act: tap delete icon
      await tester.tap(find.byIcon(Icons.cancel_outlined));
      await tester.pumpAndSettle();
      expect(deleted, true);
    });

    testWidgets('omits leading icon and delete button when not provided', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithApp(
          CityListItem(
            city: 'London',
            country: 'GB',
            temperature: '20°',
            weatherIcon: Icons.cloud,
            onTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert only provided widgets exist
      expect(find.text('London'), findsOneWidget);
      expect(find.byIcon(Icons.cancel_outlined), findsNothing);
      expect(find.byIcon(Icons.history), findsNothing);
    });
  });
}

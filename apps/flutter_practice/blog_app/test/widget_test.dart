import 'package:flutter_test/flutter_test.dart';
import 'package:blog_app/core/theme/app_colors.dart';
import 'package:blog_app/core/constants/mock_data.dart';
import 'package:blog_app/main.dart';

void main() {
  test('AppColors brand verification', () {
    expect(AppColors.primary.toARGB32(), equals(0xFF5B1921));
    expect(AppColors.background.toARGB32(), equals(0xFFFFFEFA));
    expect(AppColors.cappuccinoPink.toARGB32(), equals(0xFFD8555F));
    expect(AppColors.croissantBlue.toARGB32(), equals(0xFF6479C3));
    expect(AppColors.navActiveCircle.toARGB32(), equals(0xFF95545C));
    expect(AppColors.navInactive.toARGB32(), equals(0xFFB1AEA3));
  });

  test('MockData validation', () {
    expect(MockData.dailyProducts.length, greaterThanOrEqualTo(2));
    expect(MockData.dailyProducts.first.name, equals('Cappuccino'));
    expect(MockData.dailyProducts[1].name, equals('Crossaint'));
    expect(MockData.specialOffers.first.title, contains('BREAKFAST'));
  });

  testWidgets('CocolocoApp renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const CocolocoApp());
    expect(find.text("Let’s get this day going"), findsOneWidget);
    expect(find.text("April special"), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text("Cappuccino"), findsOneWidget);
  });
}

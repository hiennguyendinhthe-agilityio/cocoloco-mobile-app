import 'package:flutter_test/flutter_test.dart';
import 'package:blog_app/core/theme/app_colors.dart';
import 'package:blog_app/core/constants/mock_data.dart';
import 'package:blog_app/models/user_profile.dart';

void main() {
  test('AppColors brand verification', () {
    expect(AppColors.primary.toARGB32(), 0xFF6B3020);
    expect(AppColors.background.toARGB32(), 0xFFFAF7F2);
  });

  test('MockData validation', () {
    expect(MockData.currentUser.role, UserRole.admin);
    expect(MockData.currentUser.isAdmin, true);
    expect(MockData.categories.isNotEmpty, true);
    expect(MockData.samplePosts.length, greaterThanOrEqualTo(4));
  });
}

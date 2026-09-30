import 'package:flutter_test/flutter_test.dart';
import 'package:blog_app/core/services/session_service.dart';
import 'package:blog_app/models/user_profile.dart';
import 'package:blog_app/screens/clerk_webview_screen.dart';

void main() {
  group('UserProfile Model Tests', () {
    test('fromJson parses full profile with avatar_url correctly', () {
      final json = {
        'id': 'usr_test_123',
        'clerk_id': 'user_3K1qTest',
        'email': 'hien@example.com',
        'full_name': 'Nguyen Hien',
        'role': 'USER',
        'avatar_url': 'https://img.clerk.com/avatar.png',
        'is_active': true,
      };

      final profile = UserProfile.fromJson(json);

      expect(profile.id, 'usr_test_123');
      expect(profile.clerkId, 'user_3K1qTest');
      expect(profile.email, 'hien@example.com');
      expect(profile.fullName, 'Nguyen Hien');
      expect(profile.role, 'USER');
      expect(profile.avatarUrl, 'https://img.clerk.com/avatar.png');
      expect(profile.isActive, true);
      expect(profile.isAdmin, false);
    });

    test('fromJson parses admin role correctly', () {
      final json = {
        'id': 'usr_admin',
        'clerk_id': 'user_admin',
        'email': 'admin@cocoloco.vn',
        'full_name': 'Admin User',
        'role': 'ADMIN',
      };

      final profile = UserProfile.fromJson(json);

      expect(profile.isAdmin, true);
      expect(profile.avatarUrl, isNull);
    });

    test('toJson produces expected map', () {
      const profile = UserProfile(
        id: 'usr_001',
        clerkId: 'clerk_001',
        email: 'user@test.com',
        fullName: 'Test User',
        role: 'USER',
        avatarUrl: 'https://example.com/pic.jpg',
      );

      final map = profile.toJson();

      expect(map['id'], 'usr_001');
      expect(map['email'], 'user@test.com');
      expect(map['avatar_url'], 'https://example.com/pic.jpg');
    });

    test('copyWith updates properties properly', () {
      const profile = UserProfile(
        id: 'usr_001',
        clerkId: 'clerk_001',
        email: 'user@test.com',
        fullName: 'Old Name',
        role: 'USER',
      );

      final updated = profile.copyWith(
        fullName: 'New Name',
        avatarUrl: 'https://example.com/new.png',
      );

      expect(updated.fullName, 'New Name');
      expect(updated.avatarUrl, 'https://example.com/new.png');
      expect(updated.email, 'user@test.com');
    });
  });

  group('ClerkAuthResult Tests', () {
    test('instantiates with all fields', () {
      const result = ClerkAuthResult(
        token: 'jwt_mock_token_1234567890',
        email: 'hien@example.com',
        fullName: 'Nguyen Hien',
        avatarUrl: 'https://img.clerk.com/test.png',
      );

      expect(result.token, 'jwt_mock_token_1234567890');
      expect(result.email, 'hien@example.com');
      expect(result.fullName, 'Nguyen Hien');
      expect(result.avatarUrl, 'https://img.clerk.com/test.png');
    });
  });

  group('SessionService hasLoggedOut Tests', () {
    test('logout sets hasLoggedOut to true', () {
      final session = SessionService.instance;
      session.logout();
      expect(session.hasLoggedOut, isTrue);
      expect(session.isLoggedIn, isFalse);
    });
  });
}

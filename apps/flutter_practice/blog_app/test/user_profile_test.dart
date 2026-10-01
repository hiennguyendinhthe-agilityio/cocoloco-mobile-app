import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blog_app/core/providers/network_providers.dart';
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
  group('SessionService Persistence and Restoration Tests', () {
    test('logout sets hasLoggedOut to true and clears session', () async {
      SharedPreferences.setMockInitialValues({});
      final session = SessionService.instance;
      await session.loginAs(AppRole.user);
      expect(session.isLoggedIn, isTrue);

      await session.logout();
      expect(session.hasLoggedOut, isTrue);
      expect(session.isLoggedIn, isFalse);
      expect(session.role, AppRole.guest);
      expect(session.user, isNull);
      expect(session.token, isNull);
    });

    test('init restores valid session from SharedPreferences', () async {
      const mockProfile = UserProfile(
        id: 'usr_restored_123',
        clerkId: 'user_clerk_restored',
        email: 'restored@cocoloco.vn',
        fullName: 'Restored User',
        role: 'ADMIN',
        avatarUrl: 'https://example.com/avatar.png',
      );

      SharedPreferences.setMockInitialValues({
        'cocoloco_session_role': 'admin',
        'cocoloco_session_token': 'restored_jwt_token_xyz',
        'cocoloco_session_user': jsonEncode(mockProfile.toJson()),
        'cocoloco_has_logged_out': false,
      });

      final session = SessionService.instance;
      await session.init();

      expect(session.isInitialized, isTrue);
      expect(session.isLoggedIn, isTrue);
      expect(session.isAdmin, isTrue);
      expect(session.role, AppRole.admin);
      expect(session.token, 'restored_jwt_token_xyz');
      expect(session.user?.id, 'usr_restored_123');
      expect(session.user?.fullName, 'Restored User');
      expect(session.user?.email, 'restored@cocoloco.vn');
      expect(session.hasLoggedOut, isFalse);
    });

    test('init gracefully falls back to guest on empty or corrupted storage', () async {
      SharedPreferences.setMockInitialValues({
        'cocoloco_session_role': 'user',
        'cocoloco_session_user': '{corrupted_json',
      });

      final session = SessionService.instance;
      await session.init();

      expect(session.isInitialized, isTrue);
      expect(session.isLoggedIn, isFalse);
      expect(session.role, AppRole.guest);
      expect(session.user, isNull);
      expect(session.token, isNull);
    });

    test('loginAs persists user and role to SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final session = SessionService.instance;
      await session.loginAs(AppRole.user);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('cocoloco_session_role'), 'user');
      expect(prefs.getString('cocoloco_session_token'), 'demo_customer_jwt_token');
      expect(prefs.getString('cocoloco_session_user'), isNotNull);

      final userMap = jsonDecode(prefs.getString('cocoloco_session_user')!) as Map<String, dynamic>;
      expect(userMap['full_name'], 'Thu Ha (Customer)');
    });

    test('Riverpod isAdminProvider and authRoleProvider update reactively on loginAs and logout', () async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final session = SessionService.instance;
      await session.logout();

      expect(container.read(authRoleProvider), AppRole.guest);
      expect(container.read(isAdminProvider), isFalse);
      expect(container.read(isLoggedInProvider), isFalse);

      await session.loginAs(AppRole.admin);
      expect(container.read(authRoleProvider), AppRole.admin);
      expect(container.read(isAdminProvider), isTrue);
      expect(container.read(isLoggedInProvider), isTrue);

      await session.loginAs(AppRole.user);
      expect(container.read(authRoleProvider), AppRole.user);
      expect(container.read(isAdminProvider), isFalse);
      expect(container.read(isLoggedInProvider), isTrue);

      await session.logout();
      expect(container.read(authRoleProvider), AppRole.guest);
      expect(container.read(isAdminProvider), isFalse);
      expect(container.read(isLoggedInProvider), isFalse);
    });
  });
}

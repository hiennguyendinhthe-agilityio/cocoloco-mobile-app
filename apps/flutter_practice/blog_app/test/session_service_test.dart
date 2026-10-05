import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:blog_app/core/network/api_client.dart';
import 'package:blog_app/core/services/session_service.dart';
import 'package:blog_app/models/user_profile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SessionService sessionService;
  late Dio mockDio;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockDio = Dio(BaseOptions(baseUrl: 'http://test'));
    ApiClient.instance = ApiClient.withDio(mockDio);
    sessionService = SessionService.instance;
  });

  tearDown(() async {
    await sessionService.logout();
    ApiClient.resetInstance();
  });

  group('SessionService Lifecycle & Initialization Tests', () {
    test('init restores admin session from SharedPreferences correctly', () async {
      final user = {
        'id': 'usr-admin',
        'clerk_id': 'clerk-admin',
        'email': 'admin@test.com',
        'full_name': 'Super Admin',
        'role': 'ADMIN',
      };

      SharedPreferences.setMockInitialValues({
        'cocoloco_session_role': 'admin',
        'cocoloco_session_token': 'jwt-admin-token',
        'cocoloco_session_user': jsonEncode(user),
        'cocoloco_has_logged_out': false,
      });

      await sessionService.init();

      expect(sessionService.isInitialized, isTrue);
      expect(sessionService.role, AppRole.admin);
      expect(sessionService.isAdmin, isTrue);
      expect(sessionService.isLoggedIn, isTrue);
      expect(sessionService.token, 'jwt-admin-token');
      expect(sessionService.user?.email, 'admin@test.com');
      expect(sessionService.hasLoggedOut, isFalse);
    });

    test('init restores customer user session from SharedPreferences', () async {
      final user = {
        'id': 'usr-cust',
        'clerk_id': 'clerk-cust',
        'email': 'cust@test.com',
        'full_name': 'Customer One',
        'role': 'USER',
      };

      SharedPreferences.setMockInitialValues({
        'cocoloco_session_role': 'user',
        'cocoloco_session_token': 'jwt-cust-token',
        'cocoloco_session_user': jsonEncode(user),
      });

      await sessionService.init();

      expect(sessionService.role, AppRole.user);
      expect(sessionService.isAdmin, isFalse);
      expect(sessionService.isLoggedIn, isTrue);
    });

    test('init defaults to guest when storage is empty or role is unknown', () async {
      SharedPreferences.setMockInitialValues({});

      await sessionService.init();

      expect(sessionService.role, AppRole.guest);
      expect(sessionService.isLoggedIn, isFalse);
      expect(sessionService.user, isNull);
      expect(sessionService.token, isNull);
    });
  });

  group('SessionService loginAs & logout Tests', () {
    test('loginAs sets appropriate role and user for admin, user, and guest', () async {
      await sessionService.loginAs(AppRole.admin);
      expect(sessionService.role, AppRole.admin);
      expect(sessionService.isAdmin, isTrue);
      expect(sessionService.token, 'demo_admin_jwt_token');

      await sessionService.loginAs(AppRole.user);
      expect(sessionService.role, AppRole.user);
      expect(sessionService.isAdmin, isFalse);
      expect(sessionService.token, 'demo_customer_jwt_token');

      await sessionService.loginAs(AppRole.guest);
      expect(sessionService.role, AppRole.guest);
      expect(sessionService.user, isNull);
      expect(sessionService.token, isNull);
    });

    test('logout clears user, token, resets to guest, and sets hasLoggedOut to true', () async {
      await sessionService.loginAs(AppRole.user);
      expect(sessionService.isLoggedIn, isTrue);

      await sessionService.logout();

      expect(sessionService.role, AppRole.guest);
      expect(sessionService.isLoggedIn, isFalse);
      expect(sessionService.user, isNull);
      expect(sessionService.token, isNull);
      expect(sessionService.hasLoggedOut, isTrue);
    });

    test('handleUnauthorized logs out user when session is active', () async {
      await sessionService.loginAs(AppRole.user);
      expect(sessionService.isLoggedIn, isTrue);

      await sessionService.handleUnauthorized();

      expect(sessionService.role, AppRole.guest);
      expect(sessionService.isLoggedIn, isFalse);
      expect(sessionService.token, isNull);

      // Calling handleUnauthorized again while guest is a safe no-op
      await sessionService.handleUnauthorized();
      expect(sessionService.role, AppRole.guest);
    });
  });

  group('SessionService loginWithClerkToken Tests', () {
    test('loginWithClerkToken syncs user data and sets admin role on 200 OK', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'id': 'usr-synced-1',
                  'clerk_id': 'clerk_test_123',
                  'email': 'admin@test.com',
                  'full_name': 'Admin Person',
                  'role': 'ADMIN',
                  'avatar_url': 'https://example.com/admin.jpg',
                },
              ),
            );
          },
        ),
      );

      final success = await sessionService.loginWithClerkToken(
        'valid-clerk-token',
        email: 'admin@test.com',
        fullName: 'Admin Person',
        avatarUrl: 'https://example.com/admin.jpg',
      );

      expect(success, isTrue);
      expect(sessionService.role, AppRole.admin);
      expect(sessionService.token, 'valid-clerk-token');
      expect(sessionService.user?.fullName, 'Admin Person');
      expect(sessionService.user?.avatarUrl, 'https://example.com/admin.jpg');
    });

    test('loginWithClerkToken returns false and reverts token on HTTP failure or exception', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.reject(
              DioException(
                requestOptions: options,
                response: Response(requestOptions: options, statusCode: 500),
              ),
            );
          },
        ),
      );

      final success = await sessionService.loginWithClerkToken('failing-token');
      expect(success, isFalse);
      expect(sessionService.role, AppRole.guest);
    });
  });
}

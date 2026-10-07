import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_profile.dart';
import '../errors/app_exception.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';

class SessionService extends ChangeNotifier {
  static final SessionService _instance = SessionService._internal();
  factory SessionService() => _instance;
  static SessionService get instance => _instance;

  SessionService._internal();

  static const String _kRoleKey = 'cocoloco_session_role';
  static const String _kTokenKey = 'cocoloco_session_token';
  static const String _kUserKey = 'cocoloco_session_user';
  static const String _kLoggedOutKey = 'cocoloco_has_logged_out';

  AppRole _role = AppRole.guest;
  UserProfile? _user;
  String? _token;
  String? _lastAuthError;
  bool _hasLoggedOut = false;
  bool _isInitialized = false;

  AppRole get role => _role;
  UserProfile? get user => _user;
  String? get token => _token;
  String? get lastAuthError => _lastAuthError;
  bool get isLoggedIn => _role != AppRole.guest;
  bool get isAdmin => _role == AppRole.admin;
  bool get hasLoggedOut => _hasLoggedOut;
  bool get isInitialized => _isInitialized;

  void clearAuthError() {
    _lastAuthError = null;
  }

  /// Restores session state from persistent local storage upon application launch.
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _hasLoggedOut = prefs.getBool(_kLoggedOutKey) ?? false;
      final roleStr = prefs.getString(_kRoleKey);
      final tokenStr = prefs.getString(_kTokenKey);
      final userJsonStr = prefs.getString(_kUserKey);

      if (roleStr != null && userJsonStr != null) {
        final Map<String, dynamic> userMap =
            jsonDecode(userJsonStr) as Map<String, dynamic>;
        _user = UserProfile.fromJson(userMap);
        _token = tokenStr;
        if (roleStr == 'admin') {
          _role = AppRole.admin;
        } else if (roleStr == 'user') {
          _role = AppRole.user;
        } else {
          _role = AppRole.guest;
        }
        ApiClient().setAuthToken(_token);
      } else {
        _role = AppRole.guest;
        _user = null;
        _token = null;
        ApiClient().setAuthToken(null);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          '⚠️ [SessionService] Failed to load session from storage: $e',
        );
      }
      _role = AppRole.guest;
      _user = null;
      _token = null;
      ApiClient().setAuthToken(null);
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> _persistSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_role == AppRole.guest || _user == null) {
        await prefs.remove(_kRoleKey);
        await prefs.remove(_kTokenKey);
        await prefs.remove(_kUserKey);
      } else {
        await prefs.setString(_kRoleKey, _role.name);
        if (_token != null) {
          await prefs.setString(_kTokenKey, _token!);
        } else {
          await prefs.remove(_kTokenKey);
        }
        await prefs.setString(_kUserKey, jsonEncode(_user!.toJson()));
      }
      await prefs.setBool(_kLoggedOutKey, _hasLoggedOut);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ [SessionService] Failed to persist session: $e');
      }
    }
  }

  Future<bool> loginWithClerkToken(
    String clerkToken, {
    String? email,
    String? fullName,
    String? avatarUrl,
  }) async {
    _lastAuthError = null;
    try {
      // 1. Temporarily set token to make the sync request
      ApiClient().setAuthToken(clerkToken);

      // 2. Call FastAPI backend to sync user with optional metadata
      final Map<String, dynamic> body = {};
      if (email != null && email.isNotEmpty) body['email'] = email;
      if (fullName != null && fullName.isNotEmpty) body['full_name'] = fullName;
      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        body['avatar_url'] = avatarUrl;
      }

      final response = await ApiClient().dio.post(
        ApiConstants.authSync,
        data: body.isNotEmpty ? body : null,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final roleStr = data['role'] ?? 'USER';
        _role = roleStr == 'ADMIN' ? AppRole.admin : AppRole.user;

        final resolvedEmail = (email != null && email.isNotEmpty)
            ? email
            : (data['email'] ?? '');
        final resolvedFullName = (fullName != null && fullName.isNotEmpty)
            ? fullName
            : (data['full_name'] ?? 'Cocoloco Member');
        final resolvedAvatarUrl = (avatarUrl != null && avatarUrl.isNotEmpty)
            ? avatarUrl
            : (data['avatar_url'] as String?);

        _user = UserProfile(
          id: data['id'] ?? '',
          clerkId: data['clerk_id'] ?? '',
          email: resolvedEmail,
          fullName: resolvedFullName,
          role: roleStr,
          avatarUrl: resolvedAvatarUrl,
        );
        _token = clerkToken;
        _hasLoggedOut = false;
        _lastAuthError = null;

        if (kDebugMode) {
          debugPrint(
            '🔑 [CLERK TOKEN FOR POSTMAN (${_user?.role})]: $clerkToken',
          );
        }

        notifyListeners();
        await _persistSession();
        return true;
      }
      _lastAuthError = 'Server returned unexpected status: ${response.statusCode}';
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Sync Auth Failed: $e');
      }
      if (e is DioException) {
        final inner = e.error;
        if (inner is AppException) {
          _lastAuthError = inner.message;
        } else if (e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout) {
          _lastAuthError =
              'Unable to connect to the server. Please check your network connection.';
        } else {
          _lastAuthError = e.message ?? 'Authentication sync failed.';
        }
      } else if (e is AppException) {
        _lastAuthError = e.message;
      } else {
        _lastAuthError = e.toString();
      }
      // Revert token if failed
      ApiClient().setAuthToken(_token);
      return false;
    }
  }

  Future<void> loginAs(AppRole targetRole) async {
    // Keep this for local testing without backend if needed
    _role = targetRole;
    switch (targetRole) {
      case AppRole.admin:
        _user = const UserProfile(
          id: 'usr_admin_001',
          clerkId: 'user_admin_cocoloco',
          email: 'admin@cocoloco.vn',
          fullName: 'Hien Nguyen (Admin)',
          role: 'ADMIN',
        );
        _token = 'demo_admin_jwt_token';
        _hasLoggedOut = false;
        break;
      case AppRole.user:
        _user = const UserProfile(
          id: 'usr_customer_001',
          clerkId: 'user_customer_cocoloco',
          email: 'customer@cocoloco.vn',
          fullName: 'Thu Ha (Customer)',
          role: 'USER',
        );
        _token = 'demo_customer_jwt_token';
        _hasLoggedOut = false;
        break;
      case AppRole.guest:
        _user = null;
        _token = null;
        _hasLoggedOut = false;
        break;
    }

    ApiClient().setAuthToken(_token);
    notifyListeners();
    await _persistSession();
  }

  Future<void> logout() async {
    _role = AppRole.guest;
    _user = null;
    _token = null;
    _lastAuthError = null;
    _hasLoggedOut = true;
    ApiClient().setAuthToken(null);
    notifyListeners();
    await _persistSession();
  }

  /// Safely invalidates session on HTTP 401 Unauthorized from backend.
  /// Wipes token and resets state without throwing exceptions or making network calls.
  Future<void> handleUnauthorized() async {
    if (_role == AppRole.guest && _token == null) return;
    if (kDebugMode) {
      debugPrint('🔒 [SessionService] Token expired or invalid (HTTP 401). Invalidating session.');
    }
    await logout();
  }
}

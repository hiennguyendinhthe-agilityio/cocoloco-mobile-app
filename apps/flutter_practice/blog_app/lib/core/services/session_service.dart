import 'package:flutter/foundation.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../../models/user_profile.dart';

class SessionService extends ChangeNotifier {
  static final SessionService _instance = SessionService._internal();
  factory SessionService() => _instance;
  static SessionService get instance => _instance;

  SessionService._internal();

  AppRole _role = AppRole.guest;
  UserProfile? _user;
  String? _token;
  bool _hasLoggedOut = false;

  AppRole get role => _role;
  UserProfile? get user => _user;
  String? get token => _token;
  bool get isLoggedIn => _role != AppRole.guest;
  bool get isAdmin => _role == AppRole.admin;
  bool get hasLoggedOut => _hasLoggedOut;

  Future<bool> loginWithClerkToken(
    String clerkToken, {
    String? email,
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      // 1. Temporarily set token to make the sync request
      ApiClient().setAuthToken(clerkToken);
      
      // 2. Call FastAPI backend to sync user with optional metadata
      final Map<String, dynamic> body = {};
      if (email != null && email.isNotEmpty) body['email'] = email;
      if (fullName != null && fullName.isNotEmpty) body['full_name'] = fullName;
      if (avatarUrl != null && avatarUrl.isNotEmpty) body['avatar_url'] = avatarUrl;

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
        if (kDebugMode) {
          debugPrint('🔑 [CLERK TOKEN FOR POSTMAN (${_user?.role})]: $clerkToken');
        }
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Sync Auth Failed: $e');
      }
      // Revert token if failed
      ApiClient().setAuthToken(_token);
      return false;
    }
  }

  void loginAs(AppRole targetRole) {
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
        break;
      case AppRole.guest:
        _user = null;
        _token = null;
        break;
    }

    ApiClient().setAuthToken(_token);
    notifyListeners();
  }

  void logout() {
    _role = AppRole.guest;
    _user = null;
    _token = null;
    _hasLoggedOut = true;
    ApiClient().setAuthToken(null);
    notifyListeners();
  }
}

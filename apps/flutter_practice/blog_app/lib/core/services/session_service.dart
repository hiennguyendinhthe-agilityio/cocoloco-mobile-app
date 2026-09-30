import 'package:flutter/foundation.dart';
import '../network/api_client.dart';
import '../../models/user_profile.dart';

class SessionService extends ChangeNotifier {
  static final SessionService _instance = SessionService._internal();
  factory SessionService() => _instance;
  static SessionService get instance => _instance;

  SessionService._internal();

  AppRole _role = AppRole.guest;
  UserProfile? _user;
  String? _token;

  AppRole get role => _role;
  UserProfile? get user => _user;
  String? get token => _token;
  bool get isLoggedIn => _role != AppRole.guest;
  bool get isAdmin => _role == AppRole.admin;

  void loginAs(AppRole targetRole) {
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
    ApiClient().setAuthToken(null);
    notifyListeners();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../models/user_profile.dart';
import '../services/session_service.dart';

/// Provides singleton ApiClient instance
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

/// Injects ProductRepository with ApiClient dependency
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProductRepository(apiClient: apiClient);
});

/// Injects OrderRepository with ApiClient dependency
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OrderRepository(apiClient: apiClient);
});

/// Tracks current AppRole reactively across the Riverpod tree
class AuthRoleNotifier extends Notifier<AppRole> {
  @override
  AppRole build() {
    final session = SessionService.instance;
    void listener() {
      if (state != session.role) {
        state = session.role;
      }
    }

    session.addListener(listener);
    ref.onDispose(() {
      session.removeListener(listener);
    });

    return session.role;
  }
}

final authRoleProvider = NotifierProvider<AuthRoleNotifier, AppRole>(() {
  return AuthRoleNotifier();
});

/// Reactive provider indicating whether current user has Admin privileges
final isAdminProvider = Provider<bool>((ref) {
  return ref.watch(authRoleProvider) == AppRole.admin;
});

/// Reactive provider indicating whether user is logged in
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authRoleProvider) != AppRole.guest;
});

/// Bridges SessionService with Riverpod reactively
final sessionServiceProvider = Provider<SessionService>((ref) {
  ref.watch(authRoleProvider);
  return SessionService.instance;
});


import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/repositories/product_repository.dart';
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

/// Bridges SessionService with Riverpod
final sessionServiceProvider = Provider<SessionService>((ref) {
  return SessionService.instance;
});

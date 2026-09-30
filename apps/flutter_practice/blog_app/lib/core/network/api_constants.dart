import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api/v1';
    }
    if (Platform.isAndroid) {
      // 10.0.2.2 points to host machine localhost in Android Emulator
      return 'http://10.0.2.2:8000/api/v1';
    }
    // macOS desktop, iOS Simulator
    return 'http://127.0.0.1:8000/api/v1';
  }

  static const String products = '/products';
  static const String orders = '/orders';
  static const String myOrders = '/orders/me';
  static const String authSync = '/auth/sync';

  // Clerk Authentication Configuration
  static const String clerkPublishableKey = 'pk_test_cHJvdWQtcmhpbm8tODA3NC5jbGVyay5hY2NvdW50cy5kZXYk';
  static const String clerkFrontendApi = 'https://proud-rhino-8074.clerk.accounts.dev';
  static const String clerkJwtTemplate = 'cocoloco-jwt';
}

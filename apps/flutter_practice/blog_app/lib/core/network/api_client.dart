import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_constants.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio dio;
  String? _authToken;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_authToken != null && _authToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          if (kDebugMode) {
            debugPrint('🌐 [HTTP REQ] ${options.method} -> ${options.uri}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint('✅ [HTTP RES] ${response.statusCode} <- ${response.requestOptions.uri}');
          }
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          if (kDebugMode) {
            debugPrint('❌ [HTTP ERR] ${error.response?.statusCode} <- ${error.requestOptions.uri}: ${error.message} | data: ${error.response?.data}');
          }
          return handler.next(error);
        },
      ),
    );
  }

  void setAuthToken(String? token) {
    _authToken = token;
  }
}

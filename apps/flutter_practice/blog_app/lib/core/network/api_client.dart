import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_constants.dart';
import 'error_interceptor.dart';

class ApiClient {
  static ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  static set instance(ApiClient newInstance) => _instance = newInstance;
  static void resetInstance() => _instance = ApiClient._internal();

  late final Dio dio;
  String? _authToken;

  ApiClient.withDio(this.dio);

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

    // 1. Authorization Bearer Token Interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_authToken != null && _authToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          return handler.next(options);
        },
      ),
    );

    // 2. Centralized Error Handling Interceptor
    dio.interceptors.add(ErrorInterceptor());

    // 3. Clean, Compact Logger in Debug Console (Avoids flooding console)
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: false,
          requestBody: true,
          responseBody: false,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  void setAuthToken(String? token) {
    _authToken = token;
  }
}

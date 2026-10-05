import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../errors/app_exception.dart';
import '../services/session_service.dart';

/// Centralized Dio Error Interceptor for Cocoloco Mobile App.
/// Intercepts network/HTTP errors, parses backend error envelopes (FastAPI detail schema),
/// triggers auto-logout on HTTP 401 Unauthorized, and maps errors to domain-level [AppException].
class ErrorInterceptor extends Interceptor {
  final Future<void> Function()? onUnauthorized;

  ErrorInterceptor({this.onUnauthorized});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appException = _mapDioExceptionToAppException(err);

    if (kDebugMode) {
      debugPrint(
        '🚨 [ErrorInterceptor] Mapped ${err.type} (HTTP ${err.response?.statusCode}) -> $appException',
      );
    }

    // Forward the rejected error wrapped with our strongly typed AppException
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: appException,
        message: appException.message,
      ),
    );
  }

  AppException _mapDioExceptionToAppException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.badResponse:
        return _handleBadResponse(err.response);

      case DioExceptionType.cancel:
        return const UnknownException('Request was canceled.');

      case DioExceptionType.badCertificate:
        return const NetworkException('Invalid security certificate.');

      case DioExceptionType.unknown:
      default:
        final innerError = err.error;
        if (innerError is AppException) {
          return innerError;
        }
        final message = err.message ?? 'An unknown network error occurred.';
        return UnknownException(message);
    }
  }

  AppException _handleBadResponse(Response<dynamic>? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;
    final parsedMessage = _extractMessageFromData(data);

    switch (statusCode) {
      case 400:
        return ValidationException(
          parsedMessage ?? 'Invalid request. Please verify your input.',
        );

      case 401:
        // Automatically invalidate session on 401 Unauthorized
        if (onUnauthorized != null) {
          onUnauthorized!();
        } else {
          SessionService.instance.handleUnauthorized();
        }
        return UnauthorizedException(
          parsedMessage ?? 'Your session has expired. Please sign in again.',
        );

      case 403:
        return ForbiddenException(
          parsedMessage ?? 'You do not have permission to perform this action.',
        );

      case 404:
        return NotFoundException(
          parsedMessage ?? 'The requested resource was not found.',
        );

      case 409:
        return ConflictException(
          parsedMessage ??
              'Data conflict occurred or resource is linked to other records.',
        );

      case 422:
        return ValidationException(
          parsedMessage ?? 'Invalid input data provided.',
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          parsedMessage ??
              'The server encountered an error. Please try again later.',
        );

      default:
        return UnknownException(
          parsedMessage ??
              'An unknown error occurred from the server (HTTP $statusCode).',
        );
    }
  }

  /// Parses error message from FastAPI responses.
  /// Handles:
  /// - String: "User not found"
  /// - Map: {"detail": "User not found"}
  /// - List: {"detail": [{"msg": "Field required", "loc": ["body", "name"]}]}
  String? _extractMessageFromData(dynamic data) {
    if (data == null) return null;

    if (data is String && data.trim().isNotEmpty) {
      return data.trim();
    }

    if (data is Map<String, dynamic>) {
      final detail = data['detail'];

      // FastAPI standard error detail string
      if (detail is String && detail.trim().isNotEmpty) {
        return detail.trim();
      }

      // FastAPI Pydantic validation error array
      if (detail is List && detail.isNotEmpty) {
        final messages = detail
            .map((item) {
              if (item is Map) {
                return item['msg']?.toString();
              }
              return item?.toString();
            })
            .whereType<String>()
            .where((m) => m.isNotEmpty)
            .toList();

        if (messages.isNotEmpty) {
          return messages.join('\n');
        }
      }

      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }
    }

    return null;
  }
}

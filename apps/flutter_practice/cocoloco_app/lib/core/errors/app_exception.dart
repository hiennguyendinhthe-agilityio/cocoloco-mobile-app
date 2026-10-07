/// Sealed hierarchy of domain exceptions for the Cocoloco application.
/// Provides human-friendly, standard error messages and HTTP status context.
sealed class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Thrown when device has no internet connection, DNS failure, or connection timed out.
class NetworkException extends AppException {
  const NetworkException([
    super.message =
        'Unable to connect to the server. Please check your network connection.',
  ]) : super(statusCode: null);
}

/// Thrown on HTTP 401 Unauthorized (JWT token expired, revoked, or missing).
class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'Your session has expired. Please sign in again.',
  ]) : super(statusCode: 401);
}

/// Thrown on HTTP 403 Forbidden (insufficient RBAC permissions or deactivated account).
class ForbiddenException extends AppException {
  const ForbiddenException([
    super.message = 'You do not have permission to perform this action.',
  ]) : super(statusCode: 403);
}

/// Thrown on HTTP 404 Not Found (requested product, user, or order does not exist).
class NotFoundException extends AppException {
  const NotFoundException([
    super.message = 'The requested resource was not found.',
  ]) : super(statusCode: 404);
}

/// Thrown on HTTP 409 Conflict (e.g. deleting a product that already exists in order line items).
class ConflictException extends AppException {
  const ConflictException([
    super.message =
        'Data conflict occurred or resource is linked to other records.',
  ]) : super(statusCode: 409);
}

/// Thrown on HTTP 422 Unprocessable Entity (Pydantic schema validation failures).
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException(super.message, {this.fieldErrors})
    : super(statusCode: 422);
}

/// Thrown on HTTP 500+ Internal Server Error or unexpected upstream failure.
class ServerException extends AppException {
  const ServerException([
    super.message = 'The server encountered an error. Please try again later.',
  ]) : super(statusCode: 500);
}

/// Fallback for unexpected, unclassified runtime exceptions.
class UnknownException extends AppException {
  const UnknownException([
    super.message = 'An unexpected error occurred. Please try again.',
  ]) : super(statusCode: null);
}

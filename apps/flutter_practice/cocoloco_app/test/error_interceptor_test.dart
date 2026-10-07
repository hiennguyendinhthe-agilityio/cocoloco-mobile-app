import 'package:cocoloco_app/core/errors/app_exception.dart';
import 'package:cocoloco_app/core/network/error_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ErrorInterceptor Unit Tests', () {
    late Dio dio;
    bool unauthorizedCalled = false;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'http://test.api'));
      unauthorizedCalled = false;
      dio.interceptors.add(
        ErrorInterceptor(
          onUnauthorized: () async {
            unauthorizedCalled = true;
          },
        ),
      );
    });

    test(
      'maps connection timeout and connection error to NetworkException',
      () async {
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              return handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.connectionTimeout,
                ),
                true,
              );
            },
          ),
        );

        try {
          await dio.get('/test-timeout');
          fail('Should have thrown DioException');
        } on DioException catch (e) {
          expect(e.error, isA<NetworkException>());
          expect(e.message, contains('Unable to connect to the server'));
        }
      },
    );

    test(
      'maps HTTP 400 Bad Request to ValidationException with parsed message',
      () async {
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              return handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.badResponse,
                  response: Response(
                    requestOptions: options,
                    statusCode: 400,
                    data: {'detail': 'Admin cannot disable themselves'},
                  ),
                ),
                true,
              );
            },
          ),
        );

        try {
          await dio.get('/test-400');
          fail('Should have thrown DioException');
        } on DioException catch (e) {
          expect(e.error, isA<ValidationException>());
          expect(e.message, 'Admin cannot disable themselves');
        }
      },
    );

    test(
      'maps HTTP 401 Unauthorized to UnauthorizedException and triggers SessionService',
      () async {
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              return handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.badResponse,
                  response: Response(
                    requestOptions: options,
                    statusCode: 401,
                    data: {'detail': 'Token signature has expired'},
                  ),
                ),
                true,
              );
            },
          ),
        );

        try {
          await dio.get('/test-401');
          fail('Should have thrown DioException');
        } on DioException catch (e) {
          expect(e.error, isA<UnauthorizedException>());
          expect(e.message, 'Token signature has expired');
          expect(unauthorizedCalled, isTrue);
        }
      },
    );

    test('maps HTTP 403 Forbidden to ForbiddenException', () async {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.badResponse,
                response: Response(
                  requestOptions: options,
                  statusCode: 403,
                  data: {'detail': 'User account is deactivated'},
                ),
              ),
              true,
            );
          },
        ),
      );

      try {
        await dio.get('/test-403');
        fail('Should have thrown DioException');
      } on DioException catch (e) {
        expect(e.error, isA<ForbiddenException>());
        expect(e.message, 'User account is deactivated');
      }
    });

    test('maps HTTP 404 Not Found to NotFoundException', () async {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.badResponse,
                response: Response(
                  requestOptions: options,
                  statusCode: 404,
                  data: {'detail': 'Product with ID not found'},
                ),
              ),
              true,
            );
          },
        ),
      );

      try {
        await dio.get('/test-404');
        fail('Should have thrown DioException');
      } on DioException catch (e) {
        expect(e.error, isA<NotFoundException>());
        expect(e.message, 'Product with ID not found');
      }
    });

    test('maps HTTP 409 Conflict to ConflictException', () async {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.badResponse,
                response: Response(
                  requestOptions: options,
                  statusCode: 409,
                  data: {
                    'detail': 'Cannot delete product with existing orders',
                  },
                ),
              ),
              true,
            );
          },
        ),
      );

      try {
        await dio.get('/test-409');
        fail('Should have thrown DioException');
      } on DioException catch (e) {
        expect(e.error, isA<ConflictException>());
        expect(e.message, 'Cannot delete product with existing orders');
      }
    });

    test(
      'maps HTTP 422 Unprocessable Entity with FastAPI list detail to ValidationException',
      () async {
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              return handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.badResponse,
                  response: Response(
                    requestOptions: options,
                    statusCode: 422,
                    data: {
                      'detail': [
                        {
                          'loc': ['body', 'price'],
                          'msg': 'Price must be greater than 0',
                        },
                        {
                          'loc': ['body', 'name'],
                          'msg': 'Name cannot be empty',
                        },
                      ],
                    },
                  ),
                ),
                true,
              );
            },
          ),
        );

        try {
          await dio.get('/test-422');
          fail('Should have thrown DioException');
        } on DioException catch (e) {
          expect(e.error, isA<ValidationException>());
          expect(e.message, contains('Price must be greater than 0'));
          expect(e.message, contains('Name cannot be empty'));
        }
      },
    );

    test('maps HTTP 500 Internal Server Error to ServerException', () async {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.badResponse,
                response: Response(
                  requestOptions: options,
                  statusCode: 500,
                  data: {'detail': 'Internal database connection failed'},
                ),
              ),
              true,
            );
          },
        ),
      );

      try {
        await dio.get('/test-500');
        fail('Should have thrown DioException');
      } on DioException catch (e) {
        expect(e.error, isA<ServerException>());
        expect(e.message, 'Internal database connection failed');
      }
    });

    test(
      'maps request cancel to UnknownException with canceled message',
      () async {
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              return handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.cancel,
                ),
              );
            },
          ),
        );

        try {
          await dio.get('/test-cancel');
          fail('Should have thrown DioException');
        } on DioException catch (e) {
          expect(e.error, isA<UnknownException>());
          expect(e.message, contains('canceled'));
        }
      },
    );
  });
}

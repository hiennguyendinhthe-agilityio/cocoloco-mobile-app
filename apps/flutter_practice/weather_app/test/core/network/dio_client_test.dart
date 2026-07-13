import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/network/dio_client.dart';

void main() {
  group('DioClient.create()', () {
    test('returns a non-null Dio instance', () {
      final dio = DioClient.create();
      expect(dio, isA<Dio>());
    });

    test('sets connectTimeout to 10 seconds', () {
      final dio = DioClient.create();
      expect(dio.options.connectTimeout, const Duration(seconds: 10));
    });

    test('sets receiveTimeout to 10 seconds', () {
      final dio = DioClient.create();
      expect(dio.options.receiveTimeout, const Duration(seconds: 10));
    });

    test('sets Content-Type header to application/json', () {
      final dio = DioClient.create();
      expect(
        dio.options.headers['Content-Type'],
        'application/json; charset=utf-8',
      );
    });

    test('creates multiple independent instances', () {
      final dio1 = DioClient.create();
      final dio2 = DioClient.create();
      // Each call returns a new Dio instance
      expect(identical(dio1, dio2), isFalse);
    });
  });
}

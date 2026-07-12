import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:dio/dio.dart';

void main() {
  group('BaseApiClient', () {
    const baseUrl = 'https://api.example.com';

    test('should initialize with correct baseUrl', () {
      final apiClient = BaseApiClient(baseUrl: baseUrl);
      expect(apiClient.dio.options.baseUrl, baseUrl);
    });

    test('should have default headers', () {
      final apiClient = BaseApiClient(baseUrl: baseUrl);
      expect(apiClient.dio.options.headers['Content-Type'], 'application/json');
      expect(apiClient.dio.options.headers['Accept'], 'application/json');
    });

    test('should add interceptors', () {
      final interceptor = InterceptorsWrapper();
      final apiClient = BaseApiClient(baseUrl: baseUrl, interceptors: [interceptor]);
      expect(apiClient.dio.interceptors.contains(interceptor), true);
    });
  });

  group('ApiExceptionHandler', () {
    test('should map DioExceptionType.connectionTimeout to ServerFailure', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      );

      final failure = ApiExceptionHandler.handleException(exception);

      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).errorCode, 'TIMEOUT');
    });

    test('should map DioExceptionType.badResponse to ServerFailure with status code', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 404,
          statusMessage: 'Not Found',
        ),
      );

      final failure = ApiExceptionHandler.handleException(exception);

      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).errorCode, '404');
      expect(failure.message, 'Not Found');
    });
  });
}

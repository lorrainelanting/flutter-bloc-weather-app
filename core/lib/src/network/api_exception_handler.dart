import 'package:dio/dio.dart';
import '../error/failure.dart';

/// Static helper to handle API exceptions and map them to [Failure].
class ApiExceptionHandler {
  static Failure handleException(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const ServerFailure('TIMEOUT', 'Connection timed out');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.statusMessage ?? 'Unknown server error';
          return ServerFailure(statusCode?.toString() ?? 'BAD_RESPONSE', message);
        case DioExceptionType.cancel:
          return const ServerFailure('CANCELLED', 'Request was cancelled');
        case DioExceptionType.connectionError:
          return const ServerFailure('NO_INTERNET', 'No internet connection');
        default:
          return ServerFailure('UNKNOWN', error.message ?? 'An unknown error occurred');
      }
    }
    return ServerFailure('UNKNOWN', error.toString());
  }
}

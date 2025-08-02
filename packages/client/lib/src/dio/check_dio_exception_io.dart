import 'package:client/src/exception/client_exception.dart';
import 'package:dio/dio.dart' as dio;

/// {@template check_dio_exception}
/// Checks the [dio.DioException] and tries to parse it.
///
/// There is 5 types of exceptions:
///
///   * [ConnectionException] - Connection timed out, send timed out, receive timed out, bad certificate, connection error
///
///   * [InternalServerException] - Internal server error (status code 500)
///
///   * [ResourceNotFoundException] - Resource not found (status code 404)
///
///   * [StructuredBackendException] - If the response has a status code and a body with a message
///
///   * [ClientException] - If the response has a status code, but without a body, this is bad, and should be avoided, also for unknown errors and cancelled requests
///
///
/// {@endtemplate}
Object? checkDioException(dio.DioException e) {
  switch (e.type) {
    case dio.DioExceptionType.connectionTimeout:
      return ConnectionException(message: 'Connection timed out', cause: e);
    case dio.DioExceptionType.sendTimeout:
      return ConnectionException(message: 'Send timed out', cause: e);
    case dio.DioExceptionType.receiveTimeout:
      return ConnectionException(message: 'Receive timed out', cause: e);
    case dio.DioExceptionType.badCertificate:
      return ConnectionException(message: 'Bad certificate', cause: e);
    case dio.DioExceptionType.badResponse:
      if (e.response != null && e.response?.statusCode == 500 ||
          e.response?.statusCode == 502) {
        return InternalServerException(
            message: 'Internal server error', cause: e);
      } else if (e.response != null && e.response?.statusCode == 404) {
        return ResourceNotFoundException(
            message: 'Resource not found',
            cause: e,
            statusCode: e.response?.statusCode);
      } else if (e.response != null &&
          e.response?.statusCode != null &&
          e.response?.data != null) {
        return StructuredBackendException(
            response: e.response?.data, statusCode: e.response?.statusCode);
      } else {
        return ClientException(
            message: 'Bad response with status code, but without Body',
            cause: e);
      }
    case dio.DioExceptionType.cancel:
      return ClientException(message: 'Request was cancelled', cause: e);
    case dio.DioExceptionType.connectionError:
      return ConnectionException(message: 'Connection error', cause: e);
    case dio.DioExceptionType.unknown:
      return ClientException(message: 'Unknown error', cause: e);
  }
}

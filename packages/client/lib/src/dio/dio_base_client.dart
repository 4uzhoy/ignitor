import 'package:client/src/dio/check_dio_exception_io.dart';
import 'package:dio/dio.dart';
export 'package:dio/dio.dart' show LogInterceptor;
import '../base_client.dart';
import '../exception/client_exception.dart';

const _connectTimeoutInSeconds = Duration(seconds: 10);
const _receiveTimeoutInSeconds = Duration(seconds: 30);
const _sendTimeoutInSeconds = Duration(seconds: 30);

typedef ClientProgressCallback = void Function(int count, int total);

/// {@category client}
/// {@template dio_base_client}
/// Base class for Dio-based clients.
/// It provides a basic implementation of [BaseClient] using Dio.
/// {@endtemplate}
abstract class DioBaseClient extends BaseClient {
  DioBaseClient({
    required super.baseUrl,
    List<Interceptor>? interceptors,
    Dio? dio,
    Map<String, dynamic>? headers,
  }) : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: _connectTimeoutInSeconds,
                receiveTimeout: _receiveTimeoutInSeconds,
                sendTimeout: _sendTimeoutInSeconds,
                headers: headers,
              ),
            ) {
    _dio.transformer = BackgroundTransformer();
    _dio.interceptors.addAll(interceptors ?? []);
  }

  final Dio _dio;

  Dio get dio => _dio;

  @override
  Future<Map<String, Object?>?> send(
      {required String path,
      required String method,
      Map<String, Object?>? body,
      Map<String, Object?>? headers,
      Map<String, String?>? queryParams}) async {
    try {
      final uri = buildUri(path: path, queryParams: queryParams);
      final options = Options(
        headers: headers,
        method: method,
        contentType: 'application/json',
        responseType: ResponseType.json,
      );
      final response = await _dio.request<Object>(uri.toString(),
          data: body, options: options);
      final resp = await decodeResponse(
        response.data,
        statusCode: response.statusCode,
      );
      return resp;
    } on ClientException {
      rethrow;
    } on DioException catch (e, stack) {
      final checkedException = checkDioException(e);
      if (checkedException != null) {
        Error.throwWithStackTrace(checkedException, stack);
      }

      Error.throwWithStackTrace(
        ClientException(message: e.message ?? 'null-message', cause: e),
        stack,
      );
    }
  }
}

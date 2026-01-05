import 'package:common/common.dart';
import 'package:dio/dio.dart';

/// {@template on_refresh_tokens}
/// Callback for refreshing tokens.
/// {@endtemplate}
typedef OnRefreshTokens = Future<({String accessToken, String refreshToken})>
    Function(String refreshToken);

/// {@template on_invalid_token}
/// Callback for handling invalid tokens.
/// {@endtemplate}
typedef OnInvalidToken = Future<void> Function(
    String? accessToken, String? refreshToken);

/// {@category client}
/// {@template token_store}
/// Store for access and refresh tokens.
///
/// {@endtemplate}
abstract interface class TokenStore {
  /// reset token pair
  Future<void> resetTokenPair();

  ///  Save access and refresh tokens
  Future<void> saveTokenPair(
      {required String accessToken, required String refreshToken});

  ///  Get access token or null, if it is not available
  String? getAccessToken();

  ///  Get refresh token or null, if it is not available
  String? getRefreshToken();
}

/// {@category client}
/// {@template token_refresher}
/// Abstraction for refreshing tokens and handling invalid tokens.
/// {@endtemplate}
abstract base class TokenRefresher {
  const TokenRefresher({
    required this.onInvalidToken,
    required this.onRefreshTokens,
    required this.originalDioClient,
  });

  final Dio originalDioClient;
  final OnRefreshTokens onRefreshTokens;
  final OnInvalidToken onInvalidToken;
}

final class _TokenInterceptorLogger extends LoggerAdapterBase {
  _TokenInterceptorLogger();

  @override
  String get loggerAlias => 'TokenInterceptor';
}

/// {@template token_interceptor}
/// {@endtemplate}
class TokenInterceptor extends InterceptorsWrapper {
  /// {@macro token_interceptor}
  TokenInterceptor(
      {required this.tokenStore,
      required this.tokenApiPaths,
      required this.tokenRefresher})
      : _triggerWord = 'token_not_valid',
        _loggerAdapter = _TokenInterceptorLogger();
  final TokenRefresher tokenRefresher;
  final TokenStore tokenStore;
  final LoggerAdapter _loggerAdapter;
  final String _triggerWord;
  final List<String> tokenApiPaths;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final access = tokenStore.getAccessToken();
    _loggerAdapter.verbose('onRequest ${options.path}');
    if (access != null && !isInAuthApi(options.uri.pathSegments)) {
      options.headers['Authorization'] = 'Bearer $access';
    }
    super.onRequest(options, handler);
  }

  bool isInAuthApi(List<String> otherList) {
    var isIn = false;
    for (final element in otherList) {
      if (tokenApiPaths.contains(element)) {
        return true;
      }
    }
    return isIn;
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    _loggerAdapter.error(
        'onError ${err.requestOptions.path} | statusCode: ${err.response?.statusCode} | e: ${err.error}',
        err.stackTrace);

    final isReasonToRefresh = err.response?.statusCode == 401 ||
        (err.response?.statusCode == 403 &&
            err.response?.data['code'] == _triggerWord);

    if (isReasonToRefresh) {
      final oldAccessToken = tokenStore.getAccessToken();
      final oldRefreshToken = tokenStore.getRefreshToken();
      if (oldRefreshToken == null) {
        _loggerAdapter.verbose('No refresh token, invalidating session');
        await tokenRefresher.onInvalidToken(oldAccessToken, oldRefreshToken);
        await tokenStore.resetTokenPair();
        return handler.reject(err);
      } else {
        _loggerAdapter.verbose('Refresh token is present, trying to refresh');
        try {
          final tokens = await tokenRefresher.onRefreshTokens(oldRefreshToken);
          final newAccessToken = tokens.accessToken;
          final newRefreshToken = tokens.refreshToken;
          await tokenStore.saveTokenPair(
              accessToken: newAccessToken, refreshToken: newRefreshToken);
          _loggerAdapter.verbose('Tokens refreshed, retry the request');
          final result = await _$retryRequest(err);
          return handler.resolve(
            Response(
              requestOptions: err.requestOptions,
              data: result.data,
              headers: result.headers,
              statusCode: result.statusCode,
              statusMessage: result.statusMessage,
            ),
          );
        } on DioException catch (e, st) {
          _loggerAdapter.error('Refresh failed, invalidating session', st);
          await tokenRefresher.onInvalidToken(oldAccessToken, oldRefreshToken);
          await tokenStore.resetTokenPair();
          return handler.reject(e);
        } on Object catch (e, stackTrace) {
          _loggerAdapter.error(
              'Unexpected error during refresh: $e', stackTrace);
          return handler.reject(err);
        }
      }
    } else {
      // Not 401/403 - just propagate the error further
      return handler.reject(err);
    }
  }

  Future<Response<dynamic>> _$retryRequest(DioException dioError) async {
    final requestOptions = dioError.requestOptions;
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return await tokenRefresher.originalDioClient.request(
      requestOptions.path,
      options: options,
      data: requestOptions.data,
    );
  }
}

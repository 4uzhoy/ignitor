typedef JsonMapClientResponse = Future<Map<String, Object?>?>;

/// {@category Client}
/// {@template client}
///  Client to support for making HTTP requests.
/// {@endtemplate}
abstract interface class Client {
  /// Sends a HEAD request to the given [path].
  ClientResponse head(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  });

  /// Sends a GET request to the given [path].
  ClientResponse get(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  });

  /// Sends a POST request to the given [path].
  ClientResponse post(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  });

  /// Sends a PUT request to the given [path].
  ClientResponse put(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  });

  /// Sends a DELETE request to the given [path].
  ClientResponse delete(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  });

  /// Sends a PATCH request to the given [path].
  ClientResponse patch(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  });
}

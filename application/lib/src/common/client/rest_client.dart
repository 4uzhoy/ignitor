import 'package:client/client.dart';

/// A REST client for making HTTP requests.
final class RestClient extends DioBaseClient {
  RestClient({required super.baseUrl, super.interceptors});
}

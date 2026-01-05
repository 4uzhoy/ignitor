import 'dart:convert';

import 'package:client/src/base_client.dart';
import 'package:client/src/exception/client_exception.dart';
import 'package:test/test.dart';

class _TestBaseClient extends BaseClient {
  _TestBaseClient({required super.baseUrl});

  @override
  Future<Map<String, Object?>?> send({
    required String path,
    required String method,
    Map<String, Object?>? body,
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) =>
      Future.value(null);

  List<int> encode(Map<String, Object?> body) => encodeBody(body);

  Uri build(String path, {Map<String, String?>? queryParams}) => buildUri(path: path, queryParams: queryParams);

  Future<Map<String, Object?>?> decode(Object? body, {int? statusCode}) => decodeResponse(body, statusCode: statusCode);
}

void main() {
  group('BaseClient', () {
    late _TestBaseClient client;

    setUp(() {
      client = _TestBaseClient(baseUrl: 'https://api.example.com/base');
    });

    group('encodeBody', () {
      test('encodes map to json utf8', () {
        final body = {'key': 'value'};
        final encoded = client.encode(body);
        expect(utf8.decode(encoded), json.encode(body));
      });

      test('throws ClientException for non encodable body', () {
        expect(() => client.encode({'key': Object()}), throwsA(isA<ClientException>()));
      });
    });

    group('buildUri', () {
      test('builds uri with path and query params', () {
        final uri = client.build('endpoint', queryParams: {
          'q': 'test',
          'remove': null,
        });
        expect(uri.toString(), 'https://api.example.com/base/endpoint?q=test');
      });
    });

    group('decodeResponse', () {
      test('returns data on success', () async {
        final body = json.encode({
          'data': {'id': 1}
        });
        final result = await client.decode(body);
        expect(result, {'id': 1});
      });

      test('throws StructuredBackendException on error response', () {
        final body = json.encode({
          'error': {'message': 'oops'}
        });
        expect(
          () => client.decode(body, statusCode: 400),
          throwsA(isA<StructuredBackendException>().having((e) => e.statusCode, 'statusCode', 400)),
        );
      });
    });
  });
}

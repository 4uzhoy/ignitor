import 'package:client/client.dart';

/// An abstract base class for client APIs.
/// Each API should extend this class and provide its own [node] path.
///
/// example usage:
/// ```dart
/// class JobsApi extends ClientApi {
///  JobsApi({required super.client});
/// @override
/// String get node => 'jobs';
/// Future<Response<Object>> getJobDetails(JobId id) {
///  return client.get<Object>(
///    ApiPathBuilder.node(node)
///      .node(id.value)
///      .node('details')
///      .build(),
///  );
///  }
/// }
/// ```
abstract base class ClientApi {
  const ClientApi({required this.client});
  final Client client;

  String get node;
}

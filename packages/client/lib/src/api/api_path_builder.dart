/// {@template api_path_builder}
/// A builder for constructing API paths in a structured manner.
/// {@endtemplate}
final class ApiPathBuilder {
  const ApiPathBuilder._(this._segments);

  /// Creates a new [ApiPathBuilder] starting with the given [segment].
  factory ApiPathBuilder.node(String segment) => ApiPathBuilder._([segment]);

  final List<String> _segments;

  /// Adds a segment to the path.
  /// If [segment] is null or empty, it is ignored.
  /// example usage:
  /// ```dart
  /// final path = ApiPathBuilder.node('jobs')
  ///   .node('details')
  ///   .build();
  ///  Resulting path: 'api/v1/jobs/details'
  ApiPathBuilder node(String? segment) {
    if (segment == null || segment.trim().isEmpty) return this;
    return ApiPathBuilder._([..._segments, segment]);
  }

  /// Builds the final API path as a string.
  /// finally you can customize whether to include the API prefix and version.
  String build({
    int apiVersion = 1,
    bool versionPrefix = true,
    bool apiPrefix = true,
  }) {
    final path = _segments.where((e) => e.trim().isNotEmpty).join('/');
    var resolved = StringBuffer();
    if (apiPrefix) resolved.write('api/');
    if (versionPrefix) resolved.write('v$apiVersion/');
    resolved.write(path);
    return resolved.toString();
  }

  @override
  String toString() => build();
}

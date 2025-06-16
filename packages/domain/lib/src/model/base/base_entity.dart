abstract base class $BaseEntity<T extends $BaseEntity<T>> {
  const $BaseEntity({
    required this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });
  final String id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get hasName => name != null && name!.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is $BaseEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  T copyWith({String? id}) =>
      throw UnimplementedError('copyWith is not implemented for $T');
}

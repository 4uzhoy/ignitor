/// Base class for all domain entities.
abstract base class Entity<T extends Entity<T>> {
  const Entity({
    required this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  /// Unique identifier of the entity.
  final String id;

  /// Optional human readable name.
  final String? name;

  /// Date when the entity was created.
  final DateTime? createdAt;

  /// Date when the entity was last updated.
  final DateTime? updatedAt;

  /// Indicates that [name] is not `null` or empty.
  bool get hasName => name != null && name!.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Entity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  /// Creates a copy of this entity with the given fields replaced.
  T copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      throw UnimplementedError('copyWith is not implemented for $T');
}

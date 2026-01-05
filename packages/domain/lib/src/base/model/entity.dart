import 'package:common/common.dart';

/// {@template entity}
/// Base class for entities
/// An entity is an object that is defined by its identity
/// rather than by its properties. Two entities are considered equal
/// if they have the same identity, regardless of their properties.
/// Entities are typically mutable.
/// Examples of entities include:
/// - User (identified by user ID)
/// - Order (identified by order ID)
/// Entities are often used to represent concepts in the domain
/// that require a unique identity.
/// {@endtemplate}
@immutable
abstract base class Entity {
  const Entity({
    required this.id,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  /// Unique identifier of the entity.
  final String id;

  /// Optional human readable name.
  final String? name;

  /// Optional description of the entity.
  final String? description;

  /// Date when the entity was created.
  final DateTime? createdAt;

  /// Date when the entity was last updated.
  final DateTime? updatedAt;

  /// Indicates that [name] is not `null` or empty.
  bool get hasName => name != null && name!.isNotEmpty;

  /// Indicates that [description] is not `null` or empty.
  bool get hasDescription => description != null && description!.isNotEmpty;

  /// Returns the ID as a code by splitting UUID.
  ///
  String get idAsCode => id.splitUuid();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Entity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

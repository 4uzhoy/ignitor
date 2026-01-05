import 'package:domain/domain.dart';

/// {@template updatable}
/// Base interface for repositories that support restoring entities
/// of type T.
/// {@endtemplate}
abstract interface class Restorable<T extends Entity> {
  /// Restore entities from sources
  /// Thats means loading all entities of type T
  /// not specific one by id
  /// if need to load specific entity thats not common interface
  /// and should be defined in specific repository
  ///
  /// Warning: This interface is distinct from Referrable.
  Future<Entities<T>> restore();
}

/// {@template updatable}
/// Base interface for repositories that support getting entities
/// of type T by reference ID.
///
/// Warning: This interface is distinct from Restorable.
/// {@endtemplate}
abstract interface class Referrable<T extends Entity> {
  /// Get entities by reference ID
  /// referenceId is a parent identifier used to fetch related entities of type T
  ///
  /// for example
  /// for fetching JobResultEntity by Job id
  /// referenceId will be Job id
  Future<Entities<T>> reference(String referenceId);
}

/// {@template updatable}
/// Base interface for repositories that support removing entities
/// of type T.
/// {@endtemplate}
abstract interface class Removable {
  /// Remove entity by id
  Future<void> removeById(String id);
}

/// {@template creatable}
/// Base interface for repositories that support creating entities
/// of type E from value objects of type T.
///
/// T - ValueObject used to create entity - e.g. OrderDraft which return OrderEntity
/// {@endtemplate}
abstract interface class Creatable<T extends ValueObject, E extends Entity> {
  /// Create a new entity from value object
  Future<E> create(T value);
}

/// {@template throwable}
/// Base interface for repositories that can throw exceptions of type E.
/// {@endtemplate}
abstract interface class Throwable<E extends Exception> {
  /// Throws exception if operation fails
  ///
  /// Used to indicate that an operation can fail and will throw an exception
  /// instead of returning a value.
  Never throwException(E exception);
}

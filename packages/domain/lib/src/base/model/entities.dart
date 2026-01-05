import 'package:common/common.dart';
import 'package:domain/src/base/model/entity.dart';

/// {@template entities}
/// A collection of entities of type [T].
/// Provides utility methods to manage and manipulate the collection.
/// {@endtemplate}
@immutable
class Entities<T extends Entity> {
  const Entities({required this.entities});
  Entities.empty() : entities = <T>[];

  /// Creates an Entities instance from a list of entities.
  /// WARNING: list could be null and will be treated as empty list.
  Entities.fromList(List<T>? entities)
    : entities = List<T>.unmodifiable(entities ?? []);

  Entities<T> copyWith({List<T>? entities}) =>
      Entities<T>(entities: entities ?? this.entities);

  final List<T> entities;
  T operator [](int index) => entities[index];

  int get length => entities.length;

  bool get isEmpty => entities.isEmpty;
  bool get isNotEmpty => entities.isNotEmpty;

  T? getById(String id) =>
      entities.where((e) => e.id == id).toList().firstOrNull;

  Entities<T> add(T entity) => Entities.fromList([...this.entities, entity]);

  Entities<T> addAll(Iterable<T> entities) =>
      Entities.fromList([...this.entities, ...entities]);

  Entities<T> remove(T entity) => Entities.fromList(
    this.entities.where((e) => e != entity).toList(growable: false),
  );

  Entities<T> removeById(String id) => Entities.fromList(
    this.entities.where((e) => e.id != id).toList(growable: false),
  );

  Entities<T> replace(T entity) => Entities.fromList(
    this.entities
        .map((e) => e.id == entity.id ? entity : e)
        .toList(growable: false),
  );

  Entities<T> upsert(T entity) {
    final has = this.entities.any((e) => e.id == entity.id);
    return has ? replace(entity) : add(entity);
  }

  List<T2> map<T2>(T2 Function(T e) transform) =>
      entities.map(transform).toList();

  Entities<T> clear() => Entities.empty();

  int indexWhere(bool Function(T element) test) => entities.indexWhere(test);

  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in entities) {
      if (test(element)) return element;
    }
    return null;
  }

  Entities<T> where(bool Function(T element) test) {
    final filtered = entities.where(test).toList(growable: false);
    return Entities.fromList(filtered);
  }

  @override
  String toString() => 'Entities<$T>(length: $length)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Entities<T> && other.entities == entities;
  }

  @override
  int get hashCode => entities.hashCode;
}

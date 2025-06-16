import 'package:collection/collection.dart';
import 'package:domain/src/model/base/base_entity.dart';

/// A generic class to hold a collection of entities.
class Entities<T extends $BaseEntity<T>> {
  final List<T> entities;
  Entities({required this.entities});
  Entities.empty() : entities = <T>[];

  T operator [](int index) => entities[index];

  int get length => entities.length;

  bool get isEmpty => entities.isEmpty;
  bool get isNotEmpty => entities.isNotEmpty;

  T? getById(String id) =>
      entities.firstWhereOrNull((entity) => entity.id == id);

  List<T> getAll() => List<T>.unmodifiable(entities);

  void add(T entity) => entities.add(entity);

  void remove(T entity) => entities.remove(entity);
}

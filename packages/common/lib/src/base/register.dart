/// {@template register}
/// A generic registry for storing and retrieving objects by their type.
/// {@endtemplate}
abstract class Register<T extends Object> {
  final Map<Type, T> _objcts = <Type, T>{};

  /// Register an object [entry] with its type [type]
  void register(Type type, T entry) => _objcts[type] = entry;

  /// Get an object by its Type [type]
  T? getObj(Type type) => _objcts[type];

  /// Get an object by its type [Obj]
  T? getObjBy<Obj extends T>() => _objcts[Obj];

  /// Get a list of all objects
  Iterable<T> get list => _objcts.values;

  /// Get a map of all registered objects with their types
  Map<Type, T> get objects => _objcts;

  /// Clear the registry
  void clear() => _objcts.clear();
}

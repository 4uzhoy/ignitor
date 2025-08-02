import 'package:flutter/foundation.dart';

/// Usage example:
/// ```dart
/// Mapper
/// final class UserMapper extends BaseMapper<User>
///    with BaseMapperMixin1<User, ApiUser> {
///  @override
/// User map1(ApiUser a) {
///  return User(
///  id: a.uuid,
/// name: a.fullName,
/// age: DateTime.now().year - a.birthYear,
///   );
///  }
/// }
/// ```

mixin BaseMapperMixin1<T, A> on BaseMapper<T> {
  @override
  List<Type> get objects => [A];

  T map1(A a);

  @override
  T map(List<Object?> args) {
    super._assertion(args);
    super._log(args);
    if (forcePostionIndex) {
      return map1(args[0] as A);
    }
    return map1(args.whereType<A>().single);
  }
}

mixin BaseMapperMixin2<T, A, B> on BaseMapper<T> {
  @override
  List<Type> get objects => [A, B];

  T map2(A a, B b);

  @override
  T map(List<Object?> args) {
    super._assertion(args);
    super._log(args);
    if (forcePostionIndex) {
      return map2(args[0] as A, args[1] as B);
    }
    return map2(args.whereType<A>().single, args.whereType<B>().single);
  }
}

mixin BaseMapperMixin3<T, A, B, C> on BaseMapper<T> {
  @override
  List<Type> get objects => [A, B, C];

  T map3(A a, B b, C c);

  @override
  T map(List<Object?> args) {
    super._assertion(args);
    super._log(args);
    if (forcePostionIndex) {
      return map3(args[0] as A, args[1] as B, args[2] as C);
    }
    return map3(
      args.whereType<A>().single,
      args.whereType<B>().single,
      args.whereType<C>().single,
    );
  }
}

mixin BaseMapperMixin4<T, A, B, C, D> on BaseMapper<T> {
  @override
  List<Type> get objects => [A, B, C, D];

  T map4(A a, B b, C c, D d);

  @override
  T map(List<Object?> args) {
    super._assertion(args);
    super._log(args);
    if (forcePostionIndex) {
      return map4(args[0] as A, args[1] as B, args[2] as C, args[3] as D);
    }
    return map4(
      args.whereType<A>().single,
      args.whereType<B>().single,
      args.whereType<C>().single,
      args.whereType<D>().single,
    );
  }
}

mixin BaseMapperMixin5<T, A, B, C, D, E> on BaseMapper<T> {
  @override
  List<Type> get objects => [A, B, C, D, E];

  T map5(A a, B b, C c, D d, E e);

  @override
  T map(List<Object?> args) {
    super._assertion(args);
    super._log(args);
    if (forcePostionIndex) {
      return map5(
        args[0] as A,
        args[1] as B,
        args[2] as C,
        args[3] as D,
        args[4] as E,
      );
    }
    return map5(
      args.whereType<A>().single,
      args.whereType<B>().single,
      args.whereType<C>().single,
      args.whereType<D>().single,
      args.whereType<E>().single,
    );
  }
}

mixin BaseMapperMixin6<T, A, B, C, D, E, F> on BaseMapper<T> {
  @override
  List<Type> get objects => [A, B, C, D, E, F];

  T map6(A a, B b, C c, D d, E e, F f);

  @override
  T map(List<Object?> args) {
    super._assertion(args);
    super._log(args);
    if (forcePostionIndex) {
      return map6(
        args[0] as A,
        args[1] as B,
        args[2] as C,
        args[3] as D,
        args[4] as E,
        args[5] as F,
      );
    }
    return map6(
      args.whereType<A>().single,
      args.whereType<B>().single,
      args.whereType<C>().single,
      args.whereType<D>().single,
      args.whereType<E>().single,
      args.whereType<F>().single,
    );
  }
}

mixin BaseMapperMixin7<T, A, B, C, D, E, F, G> on BaseMapper<T> {
  @override
  List<Type> get objects => [A, B, C, D, E, F, G];

  T map7(A a, B b, C c, D d, E e, F f, G g);

  @override
  T map(List<Object?> args) {
    super._assertion(args);
    super._log(args);
    if (forcePostionIndex) {
      return map7(
        args[0] as A,
        args[1] as B,
        args[2] as C,
        args[3] as D,
        args[4] as E,
        args[5] as F,
        args[6] as G,
      );
    }
    return map7(
      args.whereType<A>().single,
      args.whereType<B>().single,
      args.whereType<C>().single,
      args.whereType<D>().single,
      args.whereType<E>().single,
      args.whereType<F>().single,
      args.whereType<G>().single,
    );
  }
}

mixin BaseMapperMixin8<T, A, B, C, D, E, F, G, H> on BaseMapper<T> {
  @override
  List<Type> get objects => [A, B, C, D, E, F, G, H];

  T map8(A a, B b, C c, D d, E e, F f, G g, H h);

  @override
  T map(List<Object?> args) {
    super._assertion(args);
    super._log(args);
    if (forcePostionIndex) {
      return map8(
        args[0] as A,
        args[1] as B,
        args[2] as C,
        args[3] as D,
        args[4] as E,
        args[5] as F,
        args[6] as G,
        args[7] as H,
      );
    }
    return map8(
      args.whereType<A>().single,
      args.whereType<B>().single,
      args.whereType<C>().single,
      args.whereType<D>().single,
      args.whereType<E>().single,
      args.whereType<F>().single,
      args.whereType<G>().single,
      args.whereType<H>().single,
    );
  }
}

/// {@category Mapper}
/// {@template base_mapper}
/// The `BaseMapper` provides a unified interface for converting a list of runtime objects
/// into a single target object `T`, using declared mapping functions for different argument types.
///
/// Extend this class and mix in the appropriate `BaseMapperMixinN` based on the number of inputs.
/// This design supports both positional and type-based argument resolution, enabling flexibility
/// in test setups, dependency injection, and decoupled DTO-to-model conversions.
///
/// Use `forcePostionIndex` to explicitly map by index instead of relying on runtime type matching.
/// {@endtemplate}
abstract class BaseMapper<T> {
  /// The list of expected types to be mapped into [T].
  List<Type> get objects;

  /// If `true`, mapping is performed by argument index instead of type.
  /// If `false`, mapping is performed by identifying types via `.whereType<>()`.
  bool get forcePostionIndex => false;

  /// Internal check to validate passed arguments against expected [objects].
  void _assertion(List<Object?> args) {
    if (args.isEmpty || objects.isEmpty) {
      throw ArgumentError('Invalid arguments or objects');
    }
    if (args.toSet().length != objects.toSet().length) {
      throw ArgumentError(
        'Invalid number of arguments, or duplicate arguments',
      );
    }
    final missed = <Type>[];
    for (final arg in args) {
      if (!objects.contains(arg.runtimeType)) {
        missed.add(arg.runtimeType);
      }
    }
    if (missed.isNotEmpty) {
      throw ArgumentError(
        'Invalid arguments, Expected $objects, but got ${args.map((e) => e.runtimeType)}',
      );
    }
  }

  /// Debug output to show argument types and target type.
  void _log(List<Object?> args) {
    if (kDebugMode) {
      print(
        'map args: ${args.map((e) => e.runtimeType)} with type $objects to $T',
      );
    }
  }

  /// Abstract mapping method that will be implemented in mixins.
  T map(List<Object?> args);
}

/// Utility function for optional assignment logic.
/// If [condition] and [value] are non-null, returns `null`, otherwise returns [value].
T? conditionNullableSetter<N extends Object?, T>(N? condition, T? value) =>
    (condition == null || value == null) ? value : null;

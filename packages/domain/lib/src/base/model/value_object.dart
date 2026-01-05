import 'package:common/common.dart';

/// {@template value_object}
/// Base class for value objects
///
///  A value object is an object that is defined by its properties
///  rather than by a unique identity. Two value objects are considered
///  equal if all their properties are equal.
///  Value objects are typically immutable.
/// Examples of value objects include:
/// - Money (amount and currency)
/// - Date range (start date and end date)
/// Value objects are often used to represent concepts in the domain
/// that do not require a unique identity.
/// {@endtemplate}
@immutable
abstract base class ValueObject {
  const ValueObject();
  List<Object?> get props;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (other is! ValueObject) return false;
    final a = props, b = other.props;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(props);
}

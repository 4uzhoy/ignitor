import 'package:flutter/material.dart';

const double _space = 8;

/// {@template space_widget}
/// {@category Widgets}
/// A widget that provides consistent spacing in the application.
/// It is used to create gaps between widgets, ensuring a uniform layout.
/// The spacing is based on a multiple of [_space]dp, which is a common design
/// {@endtemplate}
class Space extends StatelessWidget {
  const Space._({required this.child});

  /// Creates a [Space] widget with a specific coefficient.
  factory Space.coefficient([double coefficient = 1]) {
    assert(coefficient >= 0, 'Coefficient must be non-negative');
    return Space._(child: SizedBox.square(dimension: _space * coefficient));
  }

  /// 8dp x0.5
  factory Space.xs() => Space.coefficient(0.5);

  /// 8dp x1
  factory Space.sm() => Space.coefficient();

  /// 8dp x2
  factory Space.md() => Space.coefficient(2);

  /// 8dp x3
  factory Space.lg() => Space.coefficient(3);

  /// 8dp x4
  factory Space.xl() => Space.coefficient(4);

  /// 8dp x8
  factory Space.xxl() => Space.coefficient(8);

  /// 8dp x12
  factory Space.xxxl() => Space.coefficient(12);

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

// class _Space extends EdgeInsets {
//   const _Space._([double coefficient = 1])
//     : assert(coefficient >= 0, 'Coefficient must be non-negative'),
//       super.symmetric(
//         vertical: _space * coefficient,
//         horizontal: _space * coefficient,
//       );
// }

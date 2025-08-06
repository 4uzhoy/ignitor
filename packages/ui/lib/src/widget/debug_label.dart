import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// {@template debug_label}
/// {@category Widget}
/// A widget that displays a debug label.
/// This widget is only visible in debug mode or with debug_label flag enabled in settings scope.
/// 
/// It is used to provide additional information during development or for QA testing.
/// {@endtemplate}
///
class DebugLabel extends StatelessWidget {
  /// Creates a [DebugLabel] widget with the given [label].
  const DebugLabel({required this.label, super.key});
  final Widget label;
  @override
  Widget build(BuildContext context) {
    if (kReleaseMode) return const SizedBox.shrink();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [label],
    );
  }
}

import 'package:flutter/material.dart';

/// {@template meta_status_colors}
/// {@category Theme}
/// A theme extension that provides colors for different status indicators.
/// It includes colors for success, warning, error, and info statuses.
/// This extension can be used to customize the appearance of status indicators
/// across the application.
/// The colors are defined for both light and dark themes.
/// {@endtemplate}
@immutable
class MetaStatusColors extends ThemeExtension<MetaStatusColors> {
  /// {@macro meta_status_colors}
  /// Creates a new instance of [MetaStatusColors].
  const MetaStatusColors({
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
  });

  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  @override
  MetaStatusColors copyWith({
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
  }) => MetaStatusColors(
    info: info ?? this.info,
    success: success ?? this.success,
    warning: warning ?? this.warning,
    error: error ?? this.error,
  );

  /// Controls how the properties change on theme changes
  @override
  MetaStatusColors lerp(ThemeExtension<MetaStatusColors>? other, double t) {
    if (other is! MetaStatusColors) {
      return this;
    }
    return MetaStatusColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }

  /// Controls how it displays when the instance is being passed
  /// to the `print()` method.
  @override
  String toString() =>
      'CustomColors('
      'success: $success, warning: $warning, error: $error'
      ')';

  /// The pallete for light theme
  static const light = MetaStatusColors(
    success: Color(0xff28a745),
    warning: Color(0xfff68506),
    error: Color.fromARGB(255, 204, 60, 72),
    info: Color.fromARGB(255, 62, 147, 208),
  );

  /// The pallete for dark theme
  static const dark = MetaStatusColors(
    success: Color(0xff28a745),
    warning: Color(0xfff68506),
    error: Color.fromARGB(255, 204, 60, 72),
    info: Color.fromARGB(255, 62, 147, 208),
  );
}

import 'package:flutter/material.dart';

/// {@template analytics_navigator_observer}
/// Interface for pass navigator observer to Widget layer
///
/// [T] - NavigatorObserver of concrete implementation, it could be null
///
/// {@endtemplate}
abstract interface class AnalyticsNavigatorObserver<T extends NavigatorObserver?> {
  /// Create navigator observer with [eventName] for concrete implementation
  T createNavigatorObserver(String eventName);
}

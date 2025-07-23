import 'package:analytics/src/analytics_manager.dart';
import 'package:analytics/src/event/analytics_event.dart';
import 'package:flutter/material.dart';

/// {@template analytics_widget_mixin}
///
/// Widget allowing for easy logging of analytics events.
/// This mixin should be used in any widget that needs to log analytics events.
///
/// Provide the analytics manager to the widget by using the `context.dependencies.analyticsManager`.
/// * for more information about dependencies see [Dependencies]
///
/// {@endtemplate}
mixin AnalyticsStateMixin<T extends StatefulWidget> on State<T> {
  AnalyticsManager get analyticsManager;

  /// Logs the provided [event] to analytics.
  Future<void> logEvent(BuildContext context, AnalyticsEvent event) async =>
      analyticsManager.logEvent(event).ignore();
}

/// {@macro analytics_widget_mixin}
mixin AnalyticsStatelessMixin on StatelessWidget {
  AnalyticsManager get analyticsManager;

  /// Logs the provided [event] to analytics.
  Future<void> logEvent(BuildContext context, AnalyticsEvent event) async =>
      analyticsManager.logEvent(event).ignore();
}

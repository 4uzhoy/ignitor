import 'package:analytics/src/event/analytics_event.dart';
import 'package:flutter/material.dart';

/// {@template analytics_event_history_entry}
/// Represents a single entry in the analytics event history.
/// This class is used to store information about an analytics event,
/// including its index, the event itself
/// and the type of reporter that logged the event.
/// {@endtemplate}
@immutable
class AnalyticsEventHistoryEntry {
  /// {@macro analytics_event_history_entry}
  const AnalyticsEventHistoryEntry({
    required this.index,
    required this.event,
    required this.reporterType,
    required this.timestamp,
    required this.eventFromObserver,
  });

  /// Order in the history
  final int index;

  /// The event itself
  final AnalyticsEvent event;

  /// The type of reporter (Firebase, AppMetrica, etc.)
  final Type reporterType;

  /// The time the event was created
  final DateTime timestamp;

  /// `true`, if the event came from `Observer`
  final bool eventFromObserver;

  @override
  String toString() {
    final buffer =
        StringBuffer()..write(
          '[#$index] ${event.eventName} '
          '(from: $reporterType, observer: $eventFromObserver, time: $timestamp, params: {',
        );

    if (event.hasParameters) {
      for (final key in event.parameters!.keys) {
        buffer.write('$key: ${event.parameters![key]}, ');
      }
    }
    buffer.write('}');
    return buffer.toString();
  }
}

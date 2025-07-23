import 'package:analytics/src/event/analytics_event.dart';
import 'package:analytics/src/report/analytics_event_history.dart';
import 'package:flutter/foundation.dart';

/// {@template analytics_reporter}
/// Interface for reporting analytics events.
///
/// This interface should be implemented to report [AnalyticsEvent]s to the
/// analytics service being used by the application.
///
/// See implementations of this interface:
/// - [FirebaseAnalyticsReporter]
/// {@endtemplate}
abstract interface class AnalyticsReporter {
  /// Whether the analytics reporter is enabled.
  bool get isEnabled;

  /// Initialization configuration for the analytics reporter.
  ///
  /// For example, this method could be used to initialize the analytics service with api keys.
  /// This method should be куcalled before any other methods in the class.
  Future<void> initialize();

  /// Logs the provided [event] to analytics.
  ///
  /// This method should be implemented to report the event to the analytics
  /// service being used by the application.
  ///
  /// The [event] should be logged to the analytics service as-is, including any
  /// parameters that are included with the event.
  ///
  /// The [eventFromObserver] parameter is used to determine if the event was
  /// logged by an observer. This can be used to prevent logging the event
  /// multiple times.
  /// For example, if the event is logged by an observer and the observer logs
  /// the event to the analytics service, the event should not be logged again
  /// by the analytics manager.
  Future<void> logEvent(
    AnalyticsEvent event, {
    bool eventFromObserver = false,
    bool isEnabled = false,
  });
}

abstract base class AnalyticsReporter$Base<T extends AnalyticsReporter>
    implements AnalyticsReporter {
  const AnalyticsReporter$Base();

  /// Sends the event to the history
  /// This method should be called before any other methods in the class.
  @override
  @mustCallSuper
  Future<void> logEvent(
    AnalyticsEvent event, {
    bool eventFromObserver = false,
    bool isEnabled = false,
  }) async {
    AnalyticsEventHistory.isEnabled = isEnabled;
    AnalyticsEventHistory.instance.addEvent(
      event: event,
      reporterType: T,
      eventFromObserver: eventFromObserver,
    );
  }
}

final class DebugAnalyticsReporter
    extends AnalyticsReporter$Base<DebugAnalyticsReporter> {
  @override
  bool get isEnabled => true;

  @override
  Future<void> initialize() async {
    // No initialization needed for debug reporter.
  }
}

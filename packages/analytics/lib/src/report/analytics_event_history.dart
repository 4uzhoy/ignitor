import 'dart:async';
import 'package:analytics/src/event/analytics_event.dart';
import 'package:analytics/src/event/analytics_event_history_entry.dart';
import 'package:analytics/src/report/analytics_reporter.dart';

/// {@template analytics_event_history}
/// Singleton class to manage the history of analytics events.
/// Provides methods to add events, clear history, and access the event stream.
/// This class is used to keep track of all analytics events logged by the application.
/// It allows for easy access to the history of events, including the type of reporter that logged
/// the event, the timestamp, and whether the event was logged by an observer.
/// {@endtemplate}
class AnalyticsEventHistory {
  AnalyticsEventHistory._();
 /// Singleton instance of the AnalyticsEventHistory
  static final AnalyticsEventHistory instance = AnalyticsEventHistory._();
  /// Whether the analytics event history is enabled.
  static bool isEnabled = false;

  /// List to store the history of analytics events.
  final List<AnalyticsEventHistoryEntry> _eventHistory = [];
/// Map to keep track of the count of events by reporter type.
  final Map<String, int> _typeCounter = {};

  /// Event counter
  int _eventCounter = 0;

  /// Stream controller for events (to allow subscriptions)
  final StreamController<List<AnalyticsEventHistoryEntry>>
  _eventStreamController =
      StreamController<List<AnalyticsEventHistoryEntry>>.broadcast();

  /// Event stream for UI
  Stream<List<AnalyticsEventHistoryEntry>> get eventStream =>
      _eventStreamController.stream;

  /// Get the event history (newest first)
  List<AnalyticsEventHistoryEntry> get events =>
      List.unmodifiable(_eventHistory.reversed);

  Map<String, int> get typeCounter => Map.unmodifiable(_typeCounter);

  int get eventCounter => _eventCounter;

  /// Clear the event history
  void clear() {
    _eventHistory.clear();
    _typeCounter.clear();
    _eventCounter = 0;
    _eventStreamController.add(events);
  }

  /// Add an event to the history
  void addEvent<T extends AnalyticsReporter>({
    required AnalyticsEvent event,
    required Type reporterType,
    required bool eventFromObserver,
  }) {
    _typeCounter.update(
      reporterType.toString(),
      (value) => value + 1,
      ifAbsent: () => 1,
    );
    final entry = AnalyticsEventHistoryEntry(
      index: ++_eventCounter,
      event: event,
      reporterType: reporterType,
      timestamp: DateTime.now(),
      eventFromObserver: eventFromObserver,
    );

    _eventHistory.add(entry);
    _eventStreamController.add(events);
  }

  /// Close the stream (should be called when the application is shutting down)
  void dispose() {
    _eventStreamController.close();
  }
}

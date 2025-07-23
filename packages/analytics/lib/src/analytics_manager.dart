import 'package:analytics/src/event/analytics_event.dart';
import 'package:analytics/src/report/analytics_reporter.dart';

abstract interface class AnalyticsManager {
  /// Initializes the analytics manager.
  Future<void> initialize();

  /// Logs an analytics event.
  ///
  /// The [event] should be logged to the analytics service as-is, including any
  /// parameters that are included with the event.
  Future<void> logEvent(AnalyticsEvent event, {bool eventFromObserver = false});

  bool get isEnabled;
}

abstract base class AnalyticsManager$Base implements AnalyticsManager {
  const AnalyticsManager$Base({required List<AnalyticsReporter> reporters})
    : _reporters = reporters;

  final List<AnalyticsReporter> _reporters;

  @override
  Future<void> logEvent(
    AnalyticsEvent event, {
    bool eventFromObserver = false,
  }) async {
    for (final reporter in _reporters) {
      if (reporter.isEnabled) {
        await reporter.logEvent(event, eventFromObserver: eventFromObserver);
      }
    }
  }
}

final class DefaultAnalyticsManager extends AnalyticsManager$Base {
  DefaultAnalyticsManager({
    required super.reporters,
    this.isAnalyticsEnabled = true,
    this.initializeCallback,
  });

  final Future<void> Function()? initializeCallback;
  final bool isAnalyticsEnabled;

  @override
  Future<void> initialize() => initializeCallback?.call() ?? Future.value();

  @override
  bool get isEnabled => isAnalyticsEnabled;
}

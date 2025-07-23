part of 'analytics_event_categories.dart';

/// Event category for application start events.
/// This is example of how to define a category for analytics events.
/// You can add more categories as needed.
///
/// 1. Pass category name to the constructor.
/// 2. Define events in the category by creating methods that return `AnalyticsEvent`.
/// 3. Add This class to sealed class `AnalyticsEventCategoryFactory` class.
final class AnalyticsEventCategory$Start extends AnalyticsEventCategoryFactory {
  const AnalyticsEventCategory$Start() : super('start');

  /// Event of successful initialization of the application.
  AnalyticsEvent initializationComplete({Map<String, Object?>? parameters}) =>
      createEvent('initialization_complete', parameters: parameters);
}

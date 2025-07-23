import 'package:analytics/src/event/analytics_event.dart';

part 'event_categories.dart';

/// {@template analytics_documentation}
/// ### General Analytics Guidelines
///
/// To ensure consistency and clarity in analytics implementation, it's critical to follow strict naming conventions, parameter structures, and documentation standards.
///
/// It is highly recommended to maintain a centralized Google Spreadsheet with the following columns:
/// - `event_name` — full event name in `{category}_{action}` format
/// - `params` — list of parameters with descriptions and types
/// - `comments` — concise explanation of what the event represents
/// - `priority` — importance level (`minor`, `major`, `critical`, `need_fixes`)
/// - `status` — implementation status (`planned`, `in_progress`, `done`, `deprecated`)
/// - `note` — any additional notes or clarification
///
/// Each analytics category should have its own spreadsheet tab.
///
/// Example row:
/// | event_name                   | params                                                | comments                                                  | priority | status | note                                  |
/// |-----------------------------|-------------------------------------------------------|-----------------------------------------------------------|----------|--------|----------------------------------------|
/// | form_view_screen            | screen_name = [name, age, sex, height, weight...]    | Viewing any form screen except for dedicated screens      | major    | done   |                                        |
/// | start_initialization_complete | app_version, platform, cold_start = true/false     | Successful app initialization                            | major    | done   | Sent once on app start                |
///
/// ---
///
/// ### Event Naming
///
/// Event names must follow the format:
/// `{category}_{action_or_trigger}`
///
/// Examples:
/// - `form_view_welcome_screen`
/// - `auth_error_invalid_code`
///
/// **Requirements:**
/// - Only Latin characters
/// - `snake_case`
/// - Lowercase only
/// - Must include a verb (view, click, open, close, error, success, etc.)
///
/// ---
///
/// ### Event Parameters
///
/// Each event may include optional parameters as a `Map<String, Object?>`.
/// Keys must be standardized and reused across events.
///
/// Typical parameter types:
/// - Contextual: `screen_name`, `type`, `source`, `platform`
/// - Data-related: `survey_id`, `vit_name`, `price`, `duration_days`
/// - Technical: `error_text`, `error_type`, `app_version`, `cold_start`
///
/// If a parameter is not relevant for analytics dashboards or filtering, wrap it under a `payload` key.
///
/// Example:
/// ```dart
/// parameters: {
///   'screen': 'results',
///   'survey_id': 'abc123',
///   'payload': {
///     'price_1': 1990,
///     'price_3': 4990,
///     'count_1': 3,
///     'count_3': 9
///   }
/// }
/// ```
///
/// ---
///
/// ### Code Structure
///
/// - Each category is defined in its own class extending `AnalyticsEventCategoryFactory`.
/// - Each event is defined as a method returning `AnalyticsEvent`, using `createEvent(...)`.
/// - All categories must be registered in the `AnalyticsEventCategoryFactory`.
///
/// Example:
/// ```dart
/// final class AnalyticsEventCategory$Start extends AnalyticsEventCategoryFactory {
///   const AnalyticsEventCategory$Start() : super('start');
///
///   /// Successful application initialization
///   /// * app_version — application version (e.g. "1.0.2")
///   /// * platform — platform used (android/ios)
///   /// * cold_start — indicates launch from a killed state (true/false)
///   AnalyticsEvent initializationComplete({Map<String, Object?>? parameters}) =>
///     createEvent('initialization_complete', parameters: parameters);
/// }
/// ```
/// {@endtemplate}

sealed class AnalyticsEventCategoryFactory
    extends _AnalyticsEventCategory$Base {
  /// {@macro analytics_event_factory}
  const AnalyticsEventCategoryFactory(super.category);

  /// Add your other categories here.
  const factory AnalyticsEventCategoryFactory.start() =
      AnalyticsEventCategory$Start;
}

abstract base class _AnalyticsEventFactory$Base {
  ///{@macro analytics_documentation}
  const _AnalyticsEventFactory$Base();

  AnalyticsEvent createEvent(String name, {Map<String, Object?>? parameters}) =>
      AnalyticsEvent(name, parameters: parameters);
}

abstract base class _AnalyticsEventCategory$Base
    extends _AnalyticsEventFactory$Base {
  const _AnalyticsEventCategory$Base(this.category);

  final String category;
  String get categoryName => category;

  @override
  AnalyticsEvent createEvent(String name, {Map<String, Object?>? parameters}) =>
      AnalyticsEvent('${category}_$name', parameters: parameters);
}

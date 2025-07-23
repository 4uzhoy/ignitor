# analytics

A modular, extensible analytics layer for Dart and Flutter applications.

This package provides a unified interface for logging analytics events to multiple reporting services (e.g., Firebase, AppMetrica, custom solutions). It includes built-in support for structured events, event history tracking, and convenient integration into Flutter widgets.

---

## Features

- Centralized analytics event manager
- Pluggable reporters (`AnalyticsReporter`)
- Structured event categories
- Optional event history tracking
- Widget mixins for automatic and manual logging
- Navigator observer support

---

## Core Concepts

### `AnalyticsEvent`

Represents a single analytics event, including:
- Event name (e.g., `form_view_screen`)
- Optional parameters (key-value map)

All events follow a strict naming convention for consistency. See [`analytics_documentation`](lib/src/event/analytics_documentation.dart) for detailed rules and examples.

---

## `AnalyticsManager`

Top-level orchestrator. Responsible for:
- Managing multiple `AnalyticsReporter`s
- Initializing reporters
- Forwarding events to all active reporters

Use `DefaultAnalyticsManager` for a typical implementation:

```dart
final analyticsManager = DefaultAnalyticsManager(
  reporters: [
    FirebaseAnalyticsReporter(),
    // Add other reporters here
  ],
);
await analyticsManager.initialize();
```

### AnalyticsReporter
Defines how analytics events are reported. 
For example it can be:

- FirebaseAnalyticsReporter — integration with Firebase
- AppMetricaReporter — integration with AppMetrica
- DebugAnalyticsReporter — development/debug usage

`To create your own, implement AnalyticsReporter and optionally extend AnalyticsReporter$Base<T> to enable automatic history tracking:`

```dart
class MyReporter extends AnalyticsReporter$Base<MyReporter> {
  @override
  bool get isEnabled => true;

  @override
  Future<void> initialize() async {
    // Initialize SDK, etc.
  }

  @override
  Future<void> logEvent(AnalyticsEvent event, {bool eventFromObserver = false, bool isEnabled = false}) async {
    await super.logEvent(event, eventFromObserver: eventFromObserver, isEnabled: isEnabled);
    // Send event to your service
  }
}

```

### Event History (optional)
When using AnalyticsReporter$Base, all events are stored in an internal history:

- Tracked per reporter type
- Access via AnalyticsEventHistory.instance
- Useful for testing, debugging, analytics validation

```dart
AnalyticsEventHistory.instance.eventStream.listen((entries) {
  // React to new events
});
```


### Widget integration
```dart
class MyWidget extends StatefulWidget { ... }

class _MyWidgetState extends State<MyWidget> with AnalyticsStateMixin<MyWidget> {
  @override
  AnalyticsManager get analyticsManager => context.dependencies.analyticsManager;

  void _onTap() {
    logEvent(
      context,
      const AnalyticsEventCategory$MyCourse().recClick(parameters: {
        'vit_name': 'omega3',
        'vit_title': 'Omega-3 Complex',
        'vit_dosage': 1000,
        'vit_course_duration': 30,
        'type': 'open',
      }),
    );
  }
}
```

### Naming and Documentation Standards
see the `AnalyticsEventCategoryFactory` on `packages/analytics/lib/src/event/analytics_event_categories.dart`


## Debugging

### `DeveloperAnalyticsScreen`

The package includes a built-in debugging UI that displays all events tracked during the session.
This is useful for development, validation, QA, and integration testing.

```dart
import 'package:analytics/analytics.dart';

MaterialApp(
  home: const DeveloperAnalyticsScreen(),
);
```
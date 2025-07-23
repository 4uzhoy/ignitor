import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';

void main() {
  final analyticsManager = DefaultAnalyticsManager(
    reporters: [
      // Replace with your actual reporter, e.g. FirebaseAnalyticsReporter()
      DebugAnalyticsReporter(),
    ],
  );

  runApp(MyApp(analyticsManager: analyticsManager));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.analyticsManager});

  final AnalyticsManager analyticsManager;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage(analyticsManager: analyticsManager));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.analyticsManager});

  final AnalyticsManager analyticsManager;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AnalyticsStateMixin<MyHomePage> {
  @override
  AnalyticsManager get analyticsManager => widget.analyticsManager;

  @override
  void initState() {
    super.initState();
    analyticsManager.initialize();
    logEvent(
      context,
      const AnalyticsEventCategory$Start().initializationComplete(
        parameters: {
          'app_version': '1.0.0',
          'platform': 'flutter',
          'cold_start': true,
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            logEvent(
              context,
              const AnalyticsEventCategory$Start().initializationComplete(
                parameters: {
                  'app_version': '1.0.0',
                  'platform': 'flutter',
                  'cold_start': false,
                },
              ),
            );
          },
          child: const Text('Log Initialization Event'),
        ),
      ),
    );
  }
}

/// A simple debug reporter that prints events to console.
final class DebugAnalyticsReporter
    extends AnalyticsReporter$Base<DebugAnalyticsReporter> {
  @override
  bool get isEnabled => true;

  @override
  Future<void> initialize() async {
    debugPrint('[Analytics] Debug reporter initialized');
  }

  @override
  Future<void> logEvent(
    AnalyticsEvent event, {
    bool eventFromObserver = false,
    bool isEnabled = false,
  }) async {
    await super.logEvent(
      event,
      eventFromObserver: eventFromObserver,
      isEnabled: isEnabled,
    );
    debugPrint('[Analytics] Event: ${event.name}, params: ${event.parameters}');
  }
}

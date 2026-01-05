import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';
import 'package:ignitor/src/common/widget/ignitor_app_bar.dart';
import 'package:ignitor/src/features/initialization/model/dependencies.dart';
import 'package:ignitor/src/features/quotes/widget/screen/quotes_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with AnalyticsStateMixin {
  @override
  void initState() {
    logEvent(
      context,
      const AnalyticsEventCategory$Start().showHomeScreen(
        parameters: {'timestamp': DateTime.now().toIso8601String()},
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: IgnitorAppBar.none(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: const Text('Ignitor Template'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.rocket_launch, size: 64, color: theme.primaryColor),
              const SizedBox(height: 24),
              Text(
                'Welcome to Ignitor!',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'A minimal, extensible Flutter template\nfor fast, clean and scalable app development.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const Quotes$Screen(),
                    ),
                  );
                },
                child: const Text('Watch prime example'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  AnalyticsManager Function(BuildContext context) get analyticsManager =>
      (context) => context.dependencies.analyticsManager;
}

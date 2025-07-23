import 'dart:async';

import 'package:analytics/analytics.dart';
import 'package:ignitor/src/common/util/executor/executor.dart';
import 'package:ignitor/src/common/util/executor/executor_state.dart';
import 'package:ignitor/src/common/util/executor/executor_step.dart';
import 'package:ignitor/src/common/util/logger_util.dart';
import 'package:ignitor/src/features/initialization/model/dependencies.dart';
import 'package:kv_preferences/kv_preferences.dart';
import 'package:l/l.dart';

typedef InitializationProgress = void Function(int progress, String message)?;
typedef InitializationError =
    void Function(Object error, StackTrace stackTrace);
typedef InitializationSuccess =
    FutureOr<void> Function(Dependencies dependencies);

Future<Dependencies> $initializeDependenciesViaStepExecutor({
  InitializationProgress? onProgress,
}) async {
  final loggerAdapter = _InitializationLoggerAdapter();
  final dependencies = Dependencies();

  final steps = <ExecutorStep<Dependencies>>[
    ExecutorStep('Collect logs', (_) {
      l.asBroadcastStream().listen(LogBuffer.instance.add);
      return Future.value();
    }),
    ExecutorStep('Key Value Shared Preferences', (deps) async {
      final store = KeyValueSharedPreferences();
      await store.initialization(invalidate: false);
      deps.keyValueSharedPreferences = store;
    }),

    ExecutorStep('Analytics Manager', (deps) {
      final analyticsManager = DefaultAnalyticsManager(
        reporters: [
          DebugAnalyticsReporter(),
          // Add other reporters as needed
        ],
      );
      deps.analyticsManager = analyticsManager;
      analyticsManager.logEvent(
        const AnalyticsEventCategory$Start().initializationComplete(),
      );
    }),

    // ExecutorStep(
    //   'Failure',
    //   (deps) => throw Exception('This is a failure step for testing purposes'),
    // ),
    ExecutorStep(
      'Ready to flutter',
      (_) => Future.delayed(const Duration(milliseconds: 1)),
    ),
  ];

  final executor = StepExecutor<Dependencies>(
    executorAlias: 'InitializationExecutor',
    executorSteps: steps,
    context: dependencies,
    loggerAdapter: loggerAdapter,
    continueOnError: false,
  );

  await _listenExecutor(executor.execute(), onProgress: onProgress);

  return dependencies;
}

Future<void> _listenExecutor(
  Stream<StepExecutorState<Dependencies>> stream, {
  InitializationProgress? onProgress,
}) async {
  await for (final state in stream) {
    switch (state) {
      case StepExecutorProgress():
        onProgress?.call(state.progress, state.message);
        break;
      case StepExecutorError():
        Error.throwWithStackTrace(
          'Initialization failed at step "${state.step.alias}": ${state.error}',
          state.stackTrace,
        );

      default:
        break;
    }
  }
}

class _InitializationLoggerAdapter implements LoggerAdapter {
  @override
  void error(String message, StackTrace stackTrace, {int level = 1}) =>
      l.e(message, stackTrace);

  @override
  void info(String message, {int level = 1}) => l.i(message);

  @override
  void verbose(String message, {int level = 3}) => l.v(message);
}

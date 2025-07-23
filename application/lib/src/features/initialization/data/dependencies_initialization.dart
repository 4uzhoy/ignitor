import 'dart:async';

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
  );

  await for (final state in executor.execute()) {
    if (state is StepExecutorProgress<Dependencies>) {
      onProgress?.call(state.progress, state.message);
    } else if (state is StepExecutorError<Dependencies>) {
      Error.throwWithStackTrace(
        'Initialization failed at step "${state.step.alias}": ${state.error}',
        state.stackTrace,
      );
    }
  }

  return dependencies;
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

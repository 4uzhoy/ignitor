import 'dart:async';

import 'package:ignitor/src/features/initialization/model/dependencies.dart';

typedef _InitializationStep =
    FutureOr<void> Function(Dependencies dependencies);
typedef InitializationProgress = void Function(int progress, String message)?;
typedef InitializationError =
    void Function(Object error, StackTrace stackTrace);
typedef InitializationSuccess =
    FutureOr<void> Function(Dependencies dependencies);

/// allow to delay each step of initialization
/// to simulate a real initialization process.
/// By default, it is set to 1 millisecond.
/// You can change it to a higher value to simulate a longer initialization process.
const _$stepDurationMs = 1;

final Map<String, _InitializationStep> _initializationSteps =
    <String, _InitializationStep>{
      // 'Initialize dependencies':
      //     (_) => l.asBroadcastStream().listen(LogBuffer.instance.add),
    }..addAll({
      'Ready to work!':
          (_) async => await Future.delayed(const Duration(seconds: 1)),
    });


/// Register an initialization step.
/// The [initializationStep] will be executed during the initialization process.
///
Future<Dependencies> $initializeDependencies({
  InitializationProgress onProgress,
}) async {
  const dependencies = Dependencies();
  final totalSteps = _initializationSteps.length;
  var currentStep = 0;

  for (final initializationStep in _initializationSteps.entries) {
    final stepName = initializationStep.key;
    final step = initializationStep.value;
    try {
      currentStep++;
      final percent = (currentStep / totalSteps * 100).clamp(0, 100).toInt();
      onProgress?.call(percent, stepName);
      //l.v6('Initializing step | $currentStep/$totalSteps ($percent%) | "$stepName"');
      await Future.delayed(const Duration(milliseconds: _$stepDurationMs), () async => await step(dependencies));
    } on Object catch (error, stack) {
     // l.e('Initialization failed at step "${initializationStep.key}": $error', stack);
      Error.throwWithStackTrace('Initialization failed at step "${initializationStep.key}": $error', stack);
    }
  }
  return dependencies;
  // return dependencies;
}

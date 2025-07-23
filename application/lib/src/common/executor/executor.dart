import 'dart:async';

import 'package:ignitor/src/common/executor/executor_state.dart';
import 'package:ignitor/src/common/executor/executor_step.dart';
import 'package:ignitor/src/common/util/logger_util.dart';

/// {@category Utils}
/// {@template StepExecutor}
/// StepExecutor is a utility class that manages the execution of a series of steps.
/// Each step is represented by an [ExecutorStep] and can be executed sequentially.
/// It provides progress updates and handles errors during execution.
/// The execution can be controlled to continue on errors or stop immediately.
/// {@endtemplate}
class StepExecutor<T> {
  /// {@macro StepExecutor}
  StepExecutor({
    required List<ExecutorStep<T>> executorSteps,
    required this.context,
    required this.l,
    this.continueOnError = false,
  }) : _executorSteps = executorSteps;
  final LoggerAdapter l;
  final List<ExecutorStep<T>> _executorSteps;
  final T context;

  List<ExecutorStep<T>> get steps => _executorSteps;

  /// The last state of the executor.
  StepExecutorState<T>? lastState;

  ///
  bool get completedSuccessful => !_hasErrorsInProcess;

  bool _hasErrorsInProcess = false;
  bool continueOnError;

  /// isExecuted; true if the executor has been executed at least once.
  /// This is used to determine if the executor has been run before.
  /// It is set to true after the first execution.
  bool get isExecuted => _isExecuted;

  bool _isExecuted = false;

  /// Responses or results associated with each step (if used).
  final Map<String, Object?> _errorMap = {};

  /// The last execution timestamp.
  /// This is used to track when the last execution occurred.
  DateTime? lastExecution;

  ///  Reset the execution status.
  /// This method resets the error map, responses, and execution status.
  /// It is useful to clear the state before a new execution.
  void resetExecutionStatus() {
    lastState = null;
    lastExecution = null;
    _hasErrorsInProcess = false;
    _isExecuted = false;
    _errorMap.clear();
  }

  /// Executes the steps sequentially.
  /// This method yields [StepExecutorState] updates during execution.
  /// It starts a stopwatch to measure execution time and yields progress updates.
  /// If an error occurs, it yields a [StepExecutorError] state.
  /// If all steps complete successfully, it yields a [StepExecutorComplete] state.
  /// If there are errors but execution continues, it yields a [StepExecutorCompleteWithErrors] state.
  /// Returns a stream of [StepExecutorState] updates.
  ///
  /// If [continueOnError] is true, execution will continue even if an error occurs.
  /// If false, execution stops at the first error.
  Stream<StepExecutorState<T>> execute() async* {
    final t = Stopwatch()..start();
    resetExecutionStatus();
    Object? error;
    var currentstep = 1;
    final totalsteps = _executorSteps.length;

    for (final step in _executorSteps) {
      _errorMap.putIfAbsent(step.alias, () => null);
      if (error != null && !continueOnError) {
        break;
      } else {
        l.verbose('${step.alias}  $currentstep/$totalsteps');

        yield* emit(
          StepExecutorProgress(
            context,
            lastSyncTime: lastExecution,
            progress: (currentstep * 100 ~/ totalsteps).clamp(0, 100),
            message: step.alias,
            totalSteps: totalsteps,
            currentStep: currentstep,
          ),
        );
        final stepFunction = step.fn;
        try {
          await stepFunction(context);

          l.verbose('${step.alias} Completed');
          currentstep++;
          // ignore: avoid_catches_without_on_clauses
        } on Object catch (e, st) {
          ///  Log the error with the step alias and stack trace.
          l.error('${step.alias} Failured | $e', st);

          _errorMap.update(step.alias, (value) => e);
          error = e;
          _hasErrorsInProcess = true;

          yield* emit(StepExecutorError(e, st, step, context));
        }
      }
    }

    if (error == null || continueOnError) {
      final time = t..stop();
      lastExecution = DateTime.now();
      l.verbose('Execution completed in ${time.elapsedMilliseconds}ms.');
      yield* emit(
        StepExecutorProgress.finishStep(context, lastExecution!, totalsteps),
      );
      if (_hasErrorsInProcess) {
        yield* emit(StepExecutorCompleteWithErrors(_errorMap, context));
      } else {
        yield* emit(StepExecutorComplete(context));
      }
    }
  }

  Stream<StepExecutorState<T>> emit(StepExecutorState<T> state) async* {
    lastState = state;
    yield state;
  }
}

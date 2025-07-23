import 'package:flutter/foundation.dart';
import 'package:ignitor/src/common/util/executor/executor_step.dart';

/// Base class representing the state of a [StepExecutor].
@immutable
sealed class StepExecutorState<T> extends _$BaseStepExecutorState<T> {
  const StepExecutorState(super.context);
}

abstract base class _$BaseStepExecutorState<T> {
  /// The context associated with the step executor.
  final T context;

  const _$BaseStepExecutorState(this.context);

  /// Checks if the state represents a completed execution.
  bool get isCompleted => this is StepExecutorComplete<T>;

  /// Checks if the state represents a completed execution with errors.
  bool get hasErrors => this is StepExecutorCompleteWithErrors<T>;

  /// Checks if the state represents an ongoing execution.
  bool get isInProgress => this is StepExecutorProgress<T>;

  /// Checks if the state represents an error during execution.
  bool get isError => this is StepExecutorError<T>;

  /// Checks if the execution was successful (no errors).
  bool get isSuccessful => this is StepExecutorComplete<T> && !hasErrors;

  @override
  String toString() => '$runtimeType(context: $context)';
}

/// Represents ongoing progress in the execution process.
///
/// Used to report percentage, current step index, total steps,
/// and an optional timestamp.
@immutable
final class StepExecutorProgress<T> extends StepExecutorState<T> {
  const StepExecutorProgress(
    super.context, {
    required this.progress,
    required this.message,
    required this.currentStep,
    required this.totalSteps,
    this.lastSyncTime,
  });

  /// Creates an initial progress state.
  factory StepExecutorProgress.startStep(int totalSteps, T context) =>
      StepExecutorProgress(
        context,
        progress: 0,
        message: 'Execution started',
        currentStep: 0,
        totalSteps: totalSteps,
      );

  /// Creates a final progress state with a timestamp.
  factory StepExecutorProgress.finishStep(
    T context,
    DateTime completedAt,
    int totalSteps,
  ) => StepExecutorProgress(
    context,
    progress: 100,
    message: 'Execution completed',
    lastSyncTime: completedAt,
    currentStep: totalSteps,
    totalSteps: totalSteps,
  );

  /// Progress in percent (0–100).
  final int progress;

  /// Description of the current step.
  final String message;

  /// Timestamp of when the progress was completed, if applicable.
  final DateTime? lastSyncTime;

  /// Total number of steps.
  final int totalSteps;

  /// Index of the current step (1-based).
  final int currentStep;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StepExecutorProgress &&
          runtimeType == other.runtimeType &&
          progress == other.progress &&
          message == other.message &&
          currentStep == other.currentStep &&
          totalSteps == other.totalSteps &&
          lastSyncTime == other.lastSyncTime;

  @override
  int get hashCode =>
      progress.hashCode ^
      message.hashCode ^
      currentStep.hashCode ^
      totalSteps.hashCode ^
      lastSyncTime.hashCode;
}

/// Represents successful completion of all steps.
@immutable
final class StepExecutorComplete<T> extends StepExecutorState<T> {
  const StepExecutorComplete(super.context);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StepExecutorComplete &&
          runtimeType == other.runtimeType &&
          context == other.context;

  @override
  int get hashCode => context.hashCode;
}

/// Represents partial completion with one or more errors.
@immutable
final class StepExecutorCompleteWithErrors<T> extends StepExecutorState<T> {
  const StepExecutorCompleteWithErrors(this.errors, super.context);

  /// Map of step aliases to the error object.
  final Map<String, Object?> errors;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StepExecutorCompleteWithErrors &&
          runtimeType == other.runtimeType &&
          mapEquals(errors, other.errors);

  @override
  int get hashCode => errors.hashCode;
}

/// Represents a runtime error that occurred during a step.
@immutable
final class StepExecutorError<T> extends StepExecutorState<T> {
  const StepExecutorError(
    this.error,
    this.stackTrace,
    this.step,
    super.context,
  );

  /// The step that caused the error.
  final ExecutorStep<T> step;

  /// The thrown error.
  final Object error;

  /// The associated stack trace.
  final StackTrace stackTrace;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StepExecutorError &&
          runtimeType == other.runtimeType &&
          error == other.error &&
          stackTrace == other.stackTrace &&
          step == other.step &&
          context == other.context;

  @override
  int get hashCode =>
      error.hashCode ^ stackTrace.hashCode ^ step.hashCode ^ context.hashCode;
}

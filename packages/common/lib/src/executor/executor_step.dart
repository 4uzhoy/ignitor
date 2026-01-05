import 'dart:async';

/// ExecutorStep represents a step in the synchronization process.
/// context is the type of the context that will be passed to the step function.
typedef ExecutorStepFunction<T> = FutureOr<void> Function(T context);

/// {@category Utils}
/// {@template ExecutorStep}
/// Represents a step in the synchronization process.
/// Each step has an alias for identification and a function that executes the step.
/// The function should be asynchronous and return a Future.
/// The alias is used for display purposes in the synchronization process.
/// {@endtemplate}
final class ExecutorStep<T> {
  /// {@macro ExecutorStep}
  const ExecutorStep(this.alias, this.fn, {this.metadata});

  ///  Alias for the synchronization step.
  final String alias;

  /// Function that executes the synchronization step.
  final ExecutorStepFunction<T> fn;

  /// Optional metadata for the step.
  final Map<String, Object>? metadata;
}

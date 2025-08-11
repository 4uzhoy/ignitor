import 'package:ignitor/src/common/util/executor/executor.dart';
import 'package:ignitor/src/common/util/executor/executor_step.dart';
import 'package:ignitor/src/common/util/executor/executor_state.dart';
import 'package:ignitor/src/common/util/logger_util.dart';
import 'package:test/test.dart';

class _FakeLogger implements LoggerAdapter {
  @override
  void error(String message, StackTrace stackTrace, {int level = 1}) {}

  @override
  void info(String message, {int level = 1}) {}

  @override
  void verbose(String message, {int level = 3}) {}
}

void main() {
  group('StepExecutor', () {
    late _FakeLogger logger;

    setUp(() {
      logger = _FakeLogger();
    });

    test('emits progress and completes successfully', () async {
      final steps = [
        ExecutorStep<Map<String, int>>('step1', (ctx) async {
          ctx['a'] = 1;
        }),
        ExecutorStep<Map<String, int>>('step2', (ctx) async {
          ctx['b'] = 2;
        }),
      ];

      final executor = StepExecutor(
        executorSteps: steps,
        context: <String, int>{},
        loggerAdapter: logger,
        executorAlias: 'test',
      );

      final states = await executor.execute().toList();

      expect(states[0], isA<StepExecutorProgress>()
          .having((s) => s.message, 'message', 'step1')
          .having((s) => s.progress, 'progress', 50)
          .having((s) => s.currentStep, 'currentStep', 1));

      expect(states[1], isA<StepExecutorProgress>()
          .having((s) => s.message, 'message', 'step2')
          .having((s) => s.progress, 'progress', 100)
          .having((s) => s.currentStep, 'currentStep', 2));

      expect(states[2], isA<StepExecutorProgress>()
          .having((s) => s.message, 'message', 'Execution completed')
          .having((s) => s.progress, 'progress', 100)
          .having((s) => s.currentStep, 'currentStep', 2));

      expect(states[3], isA<StepExecutorCompleted>());
      expect(executor.completedSuccessful, isTrue);
    });

    test('emits error and stops on failure', () async {
      final steps = [
        ExecutorStep<void>('step1', (ctx) async {}),
        ExecutorStep<void>('step2', (ctx) async {
          throw StateError('fail');
        }),
        ExecutorStep<void>('step3', (ctx) async {}),
      ];

      final executor = StepExecutor(
        executorSteps: steps,
        context: null,
        loggerAdapter: logger,
      );

      final states = await executor.execute().toList();

      expect(states, hasLength(3));
      expect(states[0], isA<StepExecutorProgress>()
          .having((s) => s.message, 'message', 'step1'));
      expect(states[1], isA<StepExecutorProgress>()
          .having((s) => s.message, 'message', 'step2'));
      expect(states[2], isA<StepExecutorError>()
          .having((e) => e.step.alias, 'alias', 'step2'));
    });

    test('continues after errors when continueOnError is true', () async {
      final steps = [
        ExecutorStep<void>('step1', (ctx) async {}),
        ExecutorStep<void>('step2', (ctx) async {
          throw StateError('fail');
        }),
        ExecutorStep<void>('step3', (ctx) async {}),
      ];

      final executor = StepExecutor(
        executorSteps: steps,
        context: null,
        loggerAdapter: logger,
        continueOnError: true,
      );

      final states = await executor.execute().toList();

      expect(states[0], isA<StepExecutorProgress>()
          .having((s) => s.message, 'message', 'step1'));
      expect(states[1], isA<StepExecutorProgress>()
          .having((s) => s.message, 'message', 'step2'));
      expect(states[2], isA<StepExecutorError>()
          .having((e) => e.step.alias, 'alias', 'step2'));
      expect(states[3], isA<StepExecutorProgress>()
          .having((s) => s.message, 'message', 'step3'));
      expect(states[4], isA<StepExecutorProgress>()
          .having((s) => s.message, 'message', 'Execution completed'));
      expect(states[5], isA<StepExecutorCompletedWithErrors>()
          .having((c) => c.errors.containsKey('step2'), 'has error', isTrue));
    });
  });
}


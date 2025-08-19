// ignore_for_file: prefer_inlined_adds

import 'dart:async';

import 'package:analytics/analytics.dart';
import 'package:control/control.dart';
import 'package:domain/domain.dart';
import 'package:ignitor/src/common/client/rest_client.dart';
import 'package:ignitor/src/common/controller/controller_observer.dart';
import 'package:ignitor/src/common/util/executor/executor.dart';
import 'package:ignitor/src/common/util/executor/executor_state.dart';
import 'package:ignitor/src/common/util/executor/executor_step.dart';
import 'package:ignitor/src/common/util/logger_util.dart';
import 'package:ignitor/src/features/initialization/model/dependencies.dart';
import 'package:ignitor/src/features/quotes/controller/quotes_controller.dart';
import 'package:ignitor/src/features/quotes/data/repository/quotes_repository.dart';
import 'package:ignitor/src/features/quotes/data/source/quotes_remote_data_source.dart';
import 'package:kv_preferences/kv_preferences.dart';
import 'package:l/l.dart';

final List<ExecutorStep<Dependencies>> _initializationSteps =
    <ExecutorStep<Dependencies>>[ ]
    /// ===================================
      /// --- Infrastructure Initialization ---
      /// ===================================
      ..addAll([
        ExecutorStep('Collect logs', (_) {
          l.asBroadcastStream().listen(LogBuffer.instance.add);
          return Future.value();
        }),

        ExecutorStep('Controller observer', (_) {
          Controller.observer = const ControllerObserver();
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
        ExecutorStep('Rest Client', (deps) {
          deps.restClient = RestClient(baseUrl: 'https://dummyjson.com/');
        }),
      ])
      /// ===================================
      /// --- Repositories Initialization ---
      /// ===================================
      ..addAll([
        ExecutorStep('Quotes Repository', (deps) {
          deps.quotesRepository = QuotesRepositoryImpl(
            quotesRemoteDataSource: QuotesRemoteDataSourceImpl(
              client: deps.restClient,
            ),
          );
        }),
      ])
      /// ===================================
      /// --- Controllers Initialization ---
      /// ==================================
      ..addAll([
        ExecutorStep('Quotes Controller', (deps) {
          deps.quotesController = QuotesController(
            quotesRepository: deps.quotesRepository,
          );
        }),
      ])
      // ..addAll([
      //   ExecutorStep(
      //     'Failure',
      //     (deps) =>
      //         throw Exception('This is a failure step for testing purposes'),
      //   ),
      // ])
      /// ===================================
      /// --- Finalization ---
      /// ===================================
      ..addAll([
        ExecutorStep(
          'Ready to flutter',
          (_) => Future.delayed(const Duration(milliseconds: 1)),
        ),
      ]);

Stream<StepExecutorState<Dependencies>> $initializeDependencies() async* {
  final executor = StepExecutor<Dependencies>(
    context: Dependencies(),
    executorAlias: 'InitializationExecutor',
    executorSteps: _initializationSteps,
    loggerAdapter: _InitializationLoggerAdapter(),
    continueOnError: false,
  );
  yield* executor.execute(500);
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

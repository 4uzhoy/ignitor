import 'dart:async';
import 'dart:ui';

import 'package:common/common.dart';
import 'package:flutter/widgets.dart';
import 'package:ignitor/src/features/initialization/data/dependencies_initialization.dart';
import 'package:ignitor/src/features/initialization/model/dependencies.dart';

Stream<StepExecutorState<Dependencies>> $initializeApplication() async* {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await _catchExceptions();
    yield* $initializeDependencies().timeout(const Duration(seconds: 30));
  } finally {
    //  binding.addPostFrameCallback((_) => binding.allowFirstFrame());
  }
}

Future<void> _catchExceptions() async {
  try {
    // ignore: prefer_expression_function_bodies
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      
      // ErrorUtil.logError(
      //   error,
      //   stackTrace,
      //   hint: 'ROOT ERROR\r\n${Error.safeToString(error)}',
      // ).ignore();
      return true;
    };

    final sourceFlutterError = FlutterError.onError;
    FlutterError.onError = (final details) {
      // ErrorUtil.logError(
      //   details.exception,
      //   details.stack ?? StackTrace.current,
      //   hint: 'FLUTTER ERROR\r\n$details',
      // ).ignore();
      // FlutterError.presentError(details);
      sourceFlutterError?.call(details);
    };
  } on Object catch (error, _) {
    // ErrorUtil.logError(error, stackTrace).ignore();
  }
}

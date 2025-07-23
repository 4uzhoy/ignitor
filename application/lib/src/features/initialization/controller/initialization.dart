import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:ignitor/src/features/initialization/data/dependencies_initialization.dart';
import 'package:ignitor/src/features/initialization/model/dependencies.dart';


Future<Dependencies>? _$initializeApplicationFuture;

Future<Dependencies> $initializeApplication({
  InitializationProgress? onProgress,
  InitializationSuccess? onSuccess,
  InitializationError? onError,
}) =>
    _$initializeApplicationFuture ??= Future<Dependencies>(() async {
      late final WidgetsBinding binding;
      try {
        binding = WidgetsFlutterBinding.ensureInitialized()..deferFirstFrame();
        await _catchExceptions();

        final dependencies = await $initializeDependenciesViaStepExecutor(
          onProgress: onProgress,
        ).timeout(const Duration(seconds: 30));

        await onSuccess?.call(dependencies);
        return dependencies;
      } on Object catch (e, st) {
        onError?.call(e, st);
       // ErrorUtil.logError(e, st).ignore();
        rethrow;
      } finally {
       
        binding.addPostFrameCallback((_) {
          binding.allowFirstFrame();
        });
        _$initializeApplicationFuture = null;
      }
    });


Future<void> _catchExceptions() async {
  try {
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
  } on Object catch (error, stackTrace) {
   // ErrorUtil.logError(error, stackTrace).ignore();
  }
}

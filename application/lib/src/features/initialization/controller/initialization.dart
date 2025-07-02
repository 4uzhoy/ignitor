import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:ignitor/src/features/initialization/data/dependencies_initialization.dart';
import 'package:ignitor/src/features/initialization/model/dependencies.dart';


Future<Dependencies>? _$initializaApplication;

Future<Dependencies> $initializeApplication({
  InitializationProgress? onProgress,
  InitializationSuccess? onSuccess,
  InitializationError? onError,
}) =>
    _$initializaApplication ??= Future<Dependencies>(() async {
      late final WidgetsBinding widgetsBinding;
      final stopwatch = Stopwatch()..start();
      try {
        widgetsBinding = WidgetsFlutterBinding.ensureInitialized()..deferFirstFrame();
        await _catchExceptions();
        final dependencies = await $initializeDependencies(onProgress: onProgress).timeout(const Duration(seconds: 30));
        await onSuccess?.call(dependencies);
        return dependencies;
      } on Object catch (error, stackTrace) {
        onError?.call(error, stackTrace);
       // ErrorUtil.logError(error, stackTrace).ignore();
        rethrow;
      } finally {
        stopwatch.stop();
        widgetsBinding.addPostFrameCallback((_) {
          // Closes splash screen, and show the app layout.
          widgetsBinding.allowFirstFrame();
          //final context = binding.renderViewElement;
        });
        _$initializaApplication = null;
      }
    });

/// Resets the app's state to its initial state.
@visibleForTesting
Future<void> $resetApp(Dependencies dependencies) async {}

/// Disposes the app and releases all resources.
@visibleForTesting
Future<void> $disposeApp(Dependencies dependencies) async {
}

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

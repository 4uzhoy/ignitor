import 'package:flutter/foundation.dart';

abstract class StopwatchUtil {
  StopwatchUtil._();

  // ignore: use_setters_to_change_properties
  static void setPrintFn(void Function(String message) printFn) {
    _printFn = printFn;
  }

  static void Function(String message) _printFn = print;
  static Stopwatch? _stopwatch;
  static String? _message;
  static void startStopWatch(String message) {
    if (kDebugMode) {
      _message = message;
      _printFn.call('[STOPWATCH] start ------------> $_message');
      _stopwatch = Stopwatch()..start();
    }
  }

  static void stopStopWatch() {
    if (kDebugMode) {
      _stopwatch?.stop();
      _printFn.call(
        '[STOPWATCH] stop -------------> $_message: ${_stopwatch?.elapsedMilliseconds} ms',
      );
      _message = null;
      _stopwatch = null;
    }
  }

  static T wrapFnWithStopwatch<T>({
    required T Function() function,
    String message = 'stopWatchMethod',
  }) {
    if (!kDebugMode) {
      return function();
    } else {
      startStopWatch(message);
      final result = function();
      stopStopWatch();

      return result;
    }
  }

  static Future<T> wrapFutureWithStopwatch<T>(
    String message,
    Future<T> Function() function,
  ) async {
    if (!kDebugMode) {
      return function();
    } else {
      startStopWatch(message);
      final result = await function();
      stopStopWatch();
      return result;
    }
  }
}

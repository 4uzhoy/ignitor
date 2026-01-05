import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:l/l.dart';

/// A contract for logging messages at different levels.
/// This interface defines methods for logging informational, verbose, and error messages.
/// Used to abstract logging functionality, allowing for different implementations (e.g., console, file, remote logging).
abstract interface class LoggerAdapter {
  /// A string identifier for the logger instance.
  String get loggerAlias;

  /// Logs a info
  void info(String message, {int level = 1});

  /// Logs verbose messages.
  void verbose(String message, {int level = 3});

  /// Logs an error with the specified message and stack trace.
  void error(String message, StackTrace stackTrace, {int level = 1});
}

abstract base class LoggerAdapterBase implements LoggerAdapter {
  @override
  void error(String message, StackTrace stackTrace, {int level = 1}) => l.e('[$loggerAlias] $message', stackTrace);

  @override
  void info(String message, {int level = 1}) => l.i('[$loggerAlias] $message');

  @override
  void verbose(String message, {int level = 3}) => l.v('[$loggerAlias] $message');
}

sealed class LoggerUtil {
  LoggerUtil._();

  /// Formats the log message.
  static Object messageFormatting(LogMessage logMessage) => '${timeFormat(logMessage.timestamp)} | $logMessage';

  /// Formats the time.
  static String timeFormat(DateTime time) =>
      '${time.hour}:${time.minute.toString().padLeft(2, '0')}'
      ':${time.second.toString().padLeft(2, '0')}';
}

class LogBuffer with ChangeNotifier {
  LogBuffer._internal();
  static final LogBuffer _internalSingleton = LogBuffer._internal();
  static LogBuffer get instance => _internalSingleton;

  static const int bufferLimit = 10000;
  final Queue<LogMessage> _queue = Queue<LogMessage>();

  Stream<LogMessage> get logStream => Stream.fromIterable(_queue);

  /// Get the logs
  Iterable<LogMessage> get logs => _queue;

  Iterable<LogMessage> get logsReversed => _queue.toList().reversed;

  List<LogMessage> first100Logs() => firstNLogs(n: 100);

  /// Get the first [count] logs in queue
  List<LogMessage> firstNLogs({int n = 100}) => _queue.take(n).toList();

  /// Clear the logs
  void clear() {
    _queue.clear();
    notifyListeners();
  }

  /// Add a log to the buffer
  void add(LogMessage log) {
    if (_queue.length >= bufferLimit) _queue.removeFirst();
    _queue.add(log);
    notifyListeners();
  }

  /// Add a list of logs to the buffer
  void addAll(List<LogMessage> logs) {
    final list = logs.take(bufferLimit).toList();
    if (_queue.length + logs.length >= bufferLimit) {
      final toRemove = _queue.length + list.length - bufferLimit;
      for (var i = 0; i < toRemove; i++) {
        _queue.removeFirst();
      }
    }
    _queue.addAll(list);
    notifyListeners();
  }

  @override
  void dispose() {
    _queue.clear();
    super.dispose();
  }
}

import 'dart:collection' show Queue;
import 'package:l/l.dart';

sealed class LoggerUtil {
  LoggerUtil._();

  /// Formats the log message.
  static Object messageFormatting(LogMessage logMessage) => '${timeFormat(logMessage.timestamp)} | $logMessage';

  /// Formats the time.
  static String timeFormat(DateTime time) => '${time.hour}:${time.minute.toString().padLeft(2, '0')}'
      ':${time.second.toString().padLeft(2, '0')}';
}

/// LogBuffer Singleton class
class LogBuffer  {
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
  }

  /// Add a log to the buffer
  void add(LogMessage log) {
    if (_queue.length >= bufferLimit) _queue.removeFirst();
    _queue.add(log);
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
    
  }
}

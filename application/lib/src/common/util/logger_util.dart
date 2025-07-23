/// A contract for logging messages at different levels.
/// This interface defines methods for logging informational, verbose, and error messages.
/// Used to abstract logging functionality, allowing for different implementations (e.g., console, file, remote logging).
abstract interface class LoggerAdapter {
  /// Logs a info
  void info(String message, {int level = 1});

  /// Logs verbose messages.
  void verbose(String message, {int level = 3});

  /// Logs an error with the specified message and stack trace.
  void error(String message, StackTrace stackTrace, {int level = 1});
}

import 'dart:async';
import 'dart:ui';

/// {@template debouncer}
/// An interface for debouncer implementations.
/// {@endtemplate}
abstract interface class Debouncer {
  /// Runs the provided [action] after the debounce duration.
  void run(VoidCallback action);

  /// Disposes of any resources used by the debouncer.
  void dispose();
}

/// {@template debouncer}
/// A simple (stupid as possible) debouncer implementation, mainly useful for handling input events.
/// {@endtemplate}
class SimpleDebouncer implements Debouncer {
  SimpleDebouncer({required this.milliseconds});
  final int milliseconds;
  Timer? _timer;
  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

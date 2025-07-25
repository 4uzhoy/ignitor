import 'package:flutter/material.dart';

/// {@template app_error}
/// AppError widget
/// {@endtemplate}
class ApplicationError extends StatelessWidget {
  /// {@macro app_error}
  const ApplicationError({
    this.error,
    this.lightThemeData,
    this.darkThemeData,
    super.key,
  });
  final ThemeData? lightThemeData;
  final ThemeData? darkThemeData;

  /// Error
  final Object? error;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Application Error',
    theme:
        View.of(context).platformDispatcher.platformBrightness ==
                Brightness.dark
            ? darkThemeData ?? ThemeData.dark(useMaterial3: true)
            : lightThemeData ?? ThemeData.light(useMaterial3: true),
    home: Builder(
      builder:
          (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Application Error'),
              actions: const [
                // IconButton(
                //   onPressed: () => Navigator.of(context).push(
                //     MaterialPageRoute<void>(
                //       builder: (context) => const DeveloperScreen(),
                //     ),
                //   ),
                //   icon: const Icon(
                //     developerIcon,
                //     size: 16,
                //   ),
                // ),
              ],
            ),
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    // ErrorUtil.formatMessage(error)
                    error?.toString() ?? 'Something went wrong',
                    textScaler: TextScaler.noScaling,
                  ),
                ),
              ),
            ),
          ),
    ),
    builder:
        (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        ),
  );
}

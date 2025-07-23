import 'package:flutter/material.dart';

/// {@template app_error}
/// AppError widget
/// {@endtemplate}
class AppError extends StatelessWidget {
  /// {@macro app_error}
  const AppError({
    this.error,
    super.key,
  });

  /// Error
  final Object? error;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'App Error',
        theme: View.of(context).platformDispatcher.platformBrightness == Brightness.dark
            ? ThemeData.dark(useMaterial3: true)
            : ThemeData.light(useMaterial3: true),
        home: Builder(
            builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: const Text('AppError'),
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
                )),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child!,
        ),
      );
}

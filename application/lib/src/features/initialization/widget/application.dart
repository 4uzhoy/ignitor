// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ignitor/src/features/home/widget/home_screen.dart';
import 'package:localization/localization.dart';
import 'package:ui/ui.dart';

// final ThemeNotifier themeNotifier = ThemeNotifier(lightTheme: true);

class Application extends StatelessWidget {
  const Application({super.key});
  static final _globalKey = GlobalKey(debugLabel: 'ApplicationMaterialContext');
  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    return MaterialApp(
      title: 'Ignitor Template',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const WelcomeScreen(),
      builder:
          (context, child) => KeyedSubtree(
            key: _globalKey,
            child: MediaQuery(
              data: mediaQueryData.copyWith(
                textScaler: TextScaler.linear(
                  mediaQueryData.textScaler
                      .scale(1) // settings.textScale ?? 1
                      .clamp(0.5, 2),
                ),
              ),
              child: _Banner(
                message: 'Ignitor',
                isEnabled: true,
                location: BannerLocation.topStart,
                child: child ?? const SizedBox.shrink(),
              ),
            ),
          ),
    );
  }
}

class _Banner extends StatelessWidget {
  // ignore: unused_element_parameter
  const _Banner({
    required this.child,
    required this.message,
    this.isEnabled = false,

    this.location = BannerLocation.topEnd,
    // ignore: unused_element_parameter
    this.color = Colors.red,
  });
  final bool isEnabled;
  final String message;
  final Widget child;
  final BannerLocation location;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (isEnabled)
      return Banner(
        message: message,
        location: location,
        color: color,
        child: child,
      );

    return child;
  }
}

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

    // final theme = settings.appTheme ?? AppTheme.defaultTheme;
    // final locale = settings.locale;
    return MaterialApp(
      title: 'Ignitor Template',
      // showSemanticsDebugger: true,
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      builder:
          (context, child) => MediaQuery(
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
      home: const WelcomeScreen(),
    );

    return MaterialApp.router(
      key: _globalKey,
      //  theme: theme,
      title: 'Ignitor template',
      // routerConfig: context.dependencies.appStatefullNavigation.router,
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // supportedLocales: MetaLocalization.supportedLocales,
      // locale: locale,
      builder:
          (context, child) => MediaQuery(
            data: mediaQueryData.copyWith(
              textScaler: TextScaler.linear(
                mediaQueryData.textScaler
                    .scale(1) // settings.textScale ?? 1
                    .clamp(0.5, 2),
              ),
            ),
            // data: mediaQueryData.copyWith(
            //   textScaler: TextScaler.linear(
            //     mediaQueryData.textScaler
            //         .scale(settings.textScale ?? 1)
            //         .clamp(0.5, 2),
            //   ),
            // ),
            child: _Banner(
              message: 'Ignitor Template',
              isEnabled: false,
              //  color: theme.primaryColor,
              child: child ?? const SizedBox.shrink(),
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
    super.key,

    this.location = BannerLocation.topEnd,
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

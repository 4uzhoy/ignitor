// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ignitor/src/features/home/widget/home_screen.dart';
import 'package:localization/localization.dart';
import 'package:ui/ui.dart';

// final ThemeNotifier themeNotifier = ThemeNotifier(lightTheme: true);

class Application extends StatelessWidget {
  static final _globalKey = GlobalKey(debugLabel: 'ApplicationMaterialContext');
  @override
  Widget build(BuildContext context) {
    // final settings = SettingsScope.settingsOf(context);
    final mediaQueryData = MediaQuery.of(context);

    // final theme = settings.appTheme ?? AppTheme.defaultTheme;
    // final locale = settings.locale;
    return MaterialApp(
      title: 'Flutter Demo',
     // showSemanticsDebugger: true,
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
              isDevServer: false,
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
    super.key,
    this.isDevServer = false,
    this.location,
    this.color,
  });

  final bool isDevServer;
  final Widget child;
  final BannerLocation? location;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (isDevServer) {
      return Banner(
        message: 'DEV',
        location: location ?? BannerLocation.topEnd,
        color: color ?? Colors.red,
        child: child,
      );
    }

    return child;
  }
}

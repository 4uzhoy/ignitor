import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui/ui.dart';

class InitializationSplashScreen extends StatelessWidget {
  const InitializationSplashScreen({required this.progress, this.lightThemeData, super.key, this.darkThemeData});
  final ValueListenable<({int progress, String message})> progress;
  final ThemeData? lightThemeData;
  final ThemeData? darkThemeData;
  bool get almostComplete => progress.value.progress > 90;
  bool get isLastStep => progress.value.progress == 100;
  @override
  Widget build(BuildContext context) {
    final theme =
        View.of(context).platformDispatcher.platformBrightness == Brightness.dark
            ? lightThemeData ?? ThemeData.light(useMaterial3: true)
            : darkThemeData ?? ThemeData.dark(useMaterial3: true);
    final textTheme = theme.textTheme;
    return Theme(
      data: theme,
      child: Material(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Stack(
            children: [
              Center(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    ValueListenableBuilder(
                      valueListenable: progress,
                      builder:
                          (context, value, _) => RadialProgressIndicator(
                            size: 323,
                            isCompleted: value.progress > 90,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child:
                                  value.progress > 90
                                      ? Icon(
                                        FontAwesomeIcons.check,
                                        key: const ValueKey<bool>(true),
                                        size: 170,
                                        //color: theme.colorScheme.primary,
                                        color: Theme.of(context).colorScheme.primary,
                                      )
                                      : Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Space.md(),
                                            const SizedBox(width: 100, child: Divider()),
                                            Space.md(),
                                            SizedBox(
                                              width: 246,
                                              child: Text(
                                                'Ignitor is initializing...',

                                                style: textTheme.bodyMedium!,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                            ),
                          ),
                    ),
                    if (kDebugMode)
                      Center(
                        child: ValueListenableBuilder<({String message, int progress})>(
                          valueListenable: progress,
                          builder:
                              (context, value, _) => Text(
                                value.message,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.labelSmall?.copyWith(height: 12),
                              ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

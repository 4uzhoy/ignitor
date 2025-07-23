import 'package:flutter/material.dart';
import 'package:ignitor/src/common/util/app_zone.dart';
import 'package:ignitor/src/features/initialization/controller/initialization.dart';
import 'package:ignitor/src/features/initialization/widget/application.dart';
import 'package:ignitor/src/features/initialization/widget/application_error.dart';
import 'package:ignitor/src/features/initialization/widget/inherited_dependencies.dart';
import 'package:ignitor/src/features/initialization/widget/splash_screen.dart';

void main() => appZone(entryPoint);

Future<void> entryPoint() async {
  final initializationProgress =
      ValueNotifier<({int progress, String message})>((
        progress: 0,
        message: '',
      ));
  runApp(InitializationSplashScreen(progress: initializationProgress));
  $initializeApplication(
    onProgress:
        (progress, message) =>
            initializationProgress.value = (
              progress: progress,
              message: message,
            ),
    onSuccess:
        (deps) => runApp(
          InheritedDependencies(
            dependencies: deps,
            child: _ScopeProvider(child: Application()),
          ),
        ),
    onError: (error, stackTrace) {
      runApp(AppError(error: error));
      //ErrorUtil.logError(error, stackTrace).ignore();
    },
  ).ignore();
}

class _ScopeProvider extends StatelessWidget {
  const _ScopeProvider({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

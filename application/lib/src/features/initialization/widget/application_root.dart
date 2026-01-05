import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:ignitor/src/features/initialization/model/dependencies.dart';
import 'package:ignitor/src/features/initialization/widget/application.dart';
import 'package:ignitor/src/features/initialization/widget/application_controller_scope.dart';
import 'package:ignitor/src/features/initialization/widget/application_error.dart';
import 'package:ignitor/src/features/initialization/widget/inherited_dependencies.dart';
import 'package:ignitor/src/features/initialization/widget/splash_screen.dart';

/// The root widget of the application, which initializes dependencies and
/// provides them to the rest of the app.
/// It listens to the initialization stream and updates the UI accordingly.
class ApplicationRoot extends StatelessWidget {
  const ApplicationRoot(this.initializationStream, {super.key});
  final Stream<StepExecutorState<Dependencies>> initializationStream;

  @override
  Widget build(BuildContext context) =>
      StreamBuilder<StepExecutorState<Dependencies>>(
        stream: initializationStream,
        builder: (context, snapshot) {
          final state = snapshot.data;

          switch (state) {
            case StepExecutorProgress<Dependencies>():
              return InitializationSplashScreen(
                progress: ValueNotifier((
                  progress: state.progress,
                  message: state.message,
                )),
              );
            case StepExecutorCompleted<Dependencies>():
            case StepExecutorCompletedWithErrors<Dependencies>():
              return InheritedDependencies(
                dependencies: state!.context,
                child: const _ScopeProvider(child: Application()),
              );
            case StepExecutorError<Dependencies>():
              return ApplicationError(error: state.error);
            default:
              return InitializationSplashScreen(
                progress: ValueNotifier((
                  progress: 0,
                  message: 'Initializing...',
                )),
              ); // Default splash screen
          }
        },
      );
}

class _ScopeProvider extends StatelessWidget {
  const _ScopeProvider({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => ApplicationControllerScope(child: child);
}

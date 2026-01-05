import 'package:control/control.dart';
import 'package:flutter/material.dart';
import 'package:ignitor/src/features/initialization/model/dependencies.dart';
import 'package:ignitor/src/features/quotes/controller/quotes_controller.dart';

/// Provides application-wide controllers using the dependencies from the context.
class ApplicationControllerScope extends StatelessWidget {
  const ApplicationControllerScope({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dps = context.dependencies;
    return MultiControllerScope(
      controllers: <ControllerBuilder>[
        provide<QuotesController>(
          () => QuotesController(quotesRepository: dps.quotesRepository),
        ),
      ],
      child: child,
    );
  }
}

/// Wraps a child with a ControllerScope for the given Listenable type T.
ControllerBuilder provide<T extends Listenable>(
  T Function() create, {
  Key? key,
  bool lazy = false,
}) =>
    (context, child) =>
        ControllerScope<T>(create, key: key, lazy: lazy, child: child);

/// Functional type: transforms the current child into a wrapped tree widget.
typedef ControllerBuilder = Widget Function(BuildContext context, Widget child);

/// Wraps a list to tree of C1(C2(...(Cn(child))))
class MultiControllerScope extends StatelessWidget {
  const MultiControllerScope({
    required this.controllers,
    required this.child,
    super.key,
  });

  final List<ControllerBuilder> controllers;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var tree = child;
    for (final builder in controllers.reversed) {
      tree = builder(context, tree);
    }
    return tree;
  }
}

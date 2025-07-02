import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ignitor/src/common/extensions/inherited_extension.dart';
import 'package:ignitor/src/features/initialization/model/dependencies.dart';

/// {@template dependencies_scope}
/// A widget that provides a scope for dependencies.
/// It is used to provide dependencies to the widget tree.
/// It is a proxy widget that creates a [DependenciesScope] with the given dependencies.
/// {@endtemplate}
class DependenciesScope extends StatelessWidget {
  /// {@macro dependencies_scope}
  const DependenciesScope({
    required this.dependencies,
    required this.child,
    super.key,
  });

  final Dependencies dependencies;
  final Widget child;

  /// Get the dependencies from the [context].
  static Dependencies of(BuildContext context) =>
      context.inhOf<_DependenciesInherited>(listen: false).dependencies;

  @override
  Widget build(BuildContext context) => _DependenciesInherited(
    dependencies: dependencies,
    child: _ScopeContainer(dependencies: dependencies, child: child),
  );
}

/// A scope that provides composed [DependenciesContainer].
class _DependenciesInherited extends InheritedWidget {
  const _DependenciesInherited({
    required super.child,
    required this.dependencies,
  });

  /// Container with dependencies.
  final Dependencies dependencies;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Dependencies>('dependencies', dependencies),
    );
  }

  @override
  bool updateShouldNotify(_DependenciesInherited oldWidget) =>
      !identical(dependencies, oldWidget.dependencies);
}

/// A widget that provides a scope for dependencies.
/// It is used to provide dependencies to the widget tree.
/// It is a proxy widget that creates a [_ScopeContainer] with the given dependencies.
final class _ScopeContainer extends ProxyWidget {
  const _ScopeContainer({required super.child, required this.dependencies});

  final Dependencies dependencies;

  @override
  Element createElement() => child.createElement();
}

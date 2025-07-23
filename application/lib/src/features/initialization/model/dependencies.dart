// ignore_for_file: library_private_types_in_public_api

import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';
import 'package:ignitor/src/features/initialization/widget/inherited_dependencies.dart';
import 'package:kv_preferences/kv_preferences.dart';

extension ContextX on BuildContext {
  Dependencies get dependencies => InheritedDependencies.of(this);

  KeyValueSharedPreferences get store => dependencies.keyValueSharedPreferences;

  AnalyticsManager get analytics => dependencies.analyticsManager;
}

final class Dependencies extends _$BaseDependencies
    with Controller$Dependencies, Data$Dependencies, Analytics$Dependencies {
  Dependencies();
}

base mixin Controller$Dependencies on _$BaseDependencies {
  ///Add other dependencies here as needed.
  // Example:
  // late final SomeController someController;
}

base mixin Data$Dependencies on _$BaseDependencies {
  // Define data-related dependencies here.
  // Example:
  // late final SomeRepository someRepository;
}

base mixin Analytics$Dependencies on _$BaseDependencies {
  /// Analytics manager for tracking events.
  late final AnalyticsManager analyticsManager;
}

/// Base class for dependencies initialization.
abstract base class _$BaseDependencies {
  _$BaseDependencies();

  late final KeyValueSharedPreferences keyValueSharedPreferences;
}

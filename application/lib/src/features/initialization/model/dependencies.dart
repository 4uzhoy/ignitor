// ignore_for_file: library_private_types_in_public_api

import 'package:analytics/analytics.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:ignitor/src/common/client/rest_client.dart';
import 'package:ignitor/src/features/initialization/widget/inherited_dependencies.dart';
import 'package:kv_preferences/kv_preferences.dart';

extension ContextX on BuildContext {
  Dependencies get dependencies => InheritedDependencies.of(this);

  KeyValueSharedPreferences get store => dependencies.keyValueSharedPreferences;

  AnalyticsManager get analytics => dependencies.analyticsManager;
}

final class Dependencies extends _$BaseDependencies
    with Data$Dependencies, Analytics$Dependencies {
  Dependencies();

  late final RestClient restClient;
}

base mixin Data$Dependencies on _$BaseDependencies {
  /// An prime example of a data repository.
  late final QuotesRepository quotesRepository;

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

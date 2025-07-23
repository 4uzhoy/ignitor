// ignore_for_file: library_private_types_in_public_api

import 'package:kv_preferences/kv_preferences.dart';

final class Dependencies extends _$BaseDependencies
    with Controller$Dependencies, Data$Dependencies {
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

/// Base class for dependencies initialization.
abstract base class _$BaseDependencies {
  _$BaseDependencies();

  late final KeyValueSharedPreferences keyValueSharedPreferences;
}




import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

@immutable
base class AnalyticsEvent {
  const AnalyticsEvent(this.name, {this.parameters});

  /// The name of the event.
  ///
  /// It should be a unique identifier for the event that is understood by the
  /// analytics service being used.
  final String name;

  /// The parameters of the event.
  ///
  /// Parameters are optional and can be used to provide additional context or
  /// data with the event.
  final Map<String, Object?>? parameters;

  /// Returns `true` if the event has parameters.
  bool get hasParameters => parameters != null && parameters!.isNotEmpty;

  // Извлекает категорию из имени события, учитывая категории с `_` (например, `my_course_click_button` → `my_course`).
  String get eventCategory {
    // for (final category in AnalyticsEventCategoryFactory.categoriesNames) {
    //   if (name.startsWith('${category}_')) {
    //     return category;
    //   }
    // }
    return 'unknown';
  }

  // Извлекает само название события без категории (например, `my_course_click_button` → `click_button`).
  String get eventName {
    final category = eventCategory;
    return category != 'unknown' ? name.replaceFirst('${category}_', '') : name;
  }

  @override
  String toString() {
    final buffer = StringBuffer('AnalyticsEvent(name: $name, parameters: {');
    if (parameters != null) {
      for (final key in parameters!.keys) {
        buffer.write(', $key: ${parameters![key]}');
      }
    }
    buffer.write('})');
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnalyticsEvent &&
        other.name == name &&
        const DeepCollectionEquality().equals(other.parameters, parameters);
  }

  @override
  int get hashCode => name.hashCode ^ const DeepCollectionEquality().hash(parameters);
}

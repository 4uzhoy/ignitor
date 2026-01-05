import 'package:l/l.dart';

import 'scenario.dart';

abstract class ScriptStage {
  const ScriptStage(this.name, {required this.scenarioContext});
  final String name;
  final ScenarioContext scenarioContext;

  /// Выполняет команду. Если [dryRun] — true, только логирует, но не исполняет.
  /// true — команда выполнена успешно, false — произошла ошибка.
  Future<bool> run({ bool dryRun = true});

  void saveToContext(String name, Object variable);

  T getOrFail<T>(String name) {
    final value = scenarioContext[name];
    if (value == null) {
       l.e('$name not found or invalid in context');
      throw ArgumentError('Variable $name not found in context');
    }else if (value is! T) {
      l.e('$name not found or invalid in context');
      throw ArgumentError('Variable $name is not of type ${T.toString()}');
    }
    return value as T;
  }
}

base class ScriptStage$Base extends ScriptStage {
  const ScriptStage$Base(super.name, {required super.scenarioContext});

  @override
  Future<bool> run({ bool dryRun = true}) async {
    
    if (dryRun) {
      l.v('Dry run script stage: $name');
      return true;
    }
    return false;
  }
  
  @override
  void saveToContext(String name, Object variable) {
    scenarioContext[name] = variable;
    l.v('Saved to context: $name = $variable');
  }
}

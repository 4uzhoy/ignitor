import 'package:l/l.dart';

import 'script_stage.dart';

typedef ScenarioContext = Map<String, Object>;

abstract class Scenario {
  const Scenario({ required this.scenarioContext });
  final ScenarioContext scenarioContext;

  /// Название сценария
  String get name;

  /// Список этапов (стейджей)
  List<ScriptStage> get stages;

  /// Запуск всего сценария
  Future<void> execute({bool dryRun = true}) async {
final watch = Stopwatch()..start();
    l.i('▶️ Запуск сценария "$name" (dryRun: $dryRun)');
    l.v('$name [${stages.map((e) => e.name).join(', ')}]');

    for (final stage in stages) {
      l.v('➡️ Старт этапа: ${stage.name}');

      final success = await stage.run( dryRun: dryRun).catchError((e) {
        l.e('❌ Ошибка на этапе ${stage.name}: $e');
        return false;
      });
      if (success) {
        l.i('✅ Успех: ${stage.name}');
      } else {
        l.w('⚠️ Провал: ${stage.name}');
        break;
      }
    }
    watch.stop();
  final st = watch.elapsed.inMilliseconds;
  final senconds = st ~/ 1000;
    l.v('🏁 Сценарий "$name" завершён | ${senconds}s. | ${st}ms.');
  }
}

import '../src/scenario/git_history_scenario.dart';
import '../src/utils/zone.dart';

/// Генерация отчета git history за месяц
/// * .🟢 - Half day
/// * .🟡 - Full day (🟢+🟢)
void main() => appZone(() async {
      // Можно задать конкретную дату для генерации отчета за конкретный месяц
      final targetDate = DateTime.now();

      var scenarioContext = <String, Object>{
        'targetDate': targetDate, // Опционально: укажите дату для другого месяца
      };

      await GitHistoryScenario(scenarioContext: scenarioContext).execute(dryRun: false);
    });

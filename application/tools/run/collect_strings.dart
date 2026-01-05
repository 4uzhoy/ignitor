
import '../src/scenario/collect_strings_scenario.dart';
import '../src/utils/zone.dart';

void main() => appZone(() async {
      var scnerioContext = <String, Object>{};
      await CollectStringsScenario(scenarioContext: scnerioContext).execute(dryRun: false);
    });

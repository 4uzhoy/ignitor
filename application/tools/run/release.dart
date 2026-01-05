// ignore_for_file: unused_import

import '../src/scenario/build_aab_scenario.dart';
import '../src/scenario/bumb_build_number_scenario.dart';
import '../src/scenario/push_chagelog_scenario.dart';
import '../src/utils/zone.dart';

void main() => appZone(() async {
      final scenarioContext = <String, Object>{};

      // 1. Bump build number (pubspec, iOS, Android, codegen)
      await BumpBuildNumberScenario(scenarioContext: scenarioContext).execute(dryRun: false);

      // 2. Build AAB for Google Play + APKs for testing and
      await BuildAabScenario(scenarioContext: scenarioContext).execute(dryRun: false);

      // 3. Push changelog to Telegram
      await PushChagelogScenario(scenarioContext: scenarioContext).execute(dryRun: false);


      // await UploadGooglePlayScenario(scenarioContext: scenarioContext).execute(dryRun: false);
    });

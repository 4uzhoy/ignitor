import 'package:l/l.dart';

import '../base/scenario.dart';
import '../base/script_stage.dart';
import '../common_stage.dart';
import '../utils/utils.dart';
import 'push_chagelog_scenario.dart';

final class BuildAabScenario extends Scenario {
  const BuildAabScenario({required super.scenarioContext});

  @override
  String get name => 'Build aab';

  @override
  List<ScriptStage> get stages => [
        ReadPubspecStage(scenarioContext: scenarioContext),
        BuildAabStage(scenarioContext: scenarioContext),
        BuildApkStage(scenarioContext: scenarioContext),
        RenameApkStage(scenarioContext: scenarioContext),
      ];
}

final class BuildAabStage extends ScriptStage$Base {
  BuildAabStage({required super.scenarioContext}) : super('Build aab');

  @override
  Future<bool> run({bool dryRun = true}) async {
    final buildNumber = scenarioContext['buildNumber'] as String;
    final versionName = scenarioContext['versionName'] as String;
    l.i('Build aab $versionName+$buildNumber');
    if (!dryRun) {
      await cmd(
        'flutter',
        [
          'build',
          'appbundle',
          '--release',
          '--build-name=$versionName',
          '--build-number=$buildNumber',
          '--dart-define-from-file=.config/development.json',
        ],
        workingDirectory: getProjectDir(toolsWorkspace: false).path,
      );
    }
    return true;
  }
}

final class BuildApkStage extends ScriptStage$Base {
  BuildApkStage({required super.scenarioContext}) : super('Build apk');

  @override
  Future<bool> run({bool dryRun = true}) async {
    final buildNumber = scenarioContext['buildNumber'] as String;
    final versionName = scenarioContext['versionName'] as String;
    l.i('Build apk $versionName+$buildNumber');
    if (!dryRun) {
      await cmd(
        'flutter',
        [
          'build',
          'apk',
          '--split-per-abi',
          '--release',
          '--build-name=$versionName',
          '--build-number=$buildNumber',
          '--dart-define-from-file=.config/development.json',
        ],
        workingDirectory: getProjectDir(toolsWorkspace: false).path,
      );
    }
    return true;
  }
}

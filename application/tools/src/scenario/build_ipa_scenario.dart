// import 'package:l/l.dart';


// import '../base/scenario.dart';
// import '../base/script_stage.dart';
// import '../common_stage.dart';
// import '../utils/utils.dart';

// final class BuildIpaScenario extends Scenario {
//   const BuildIpaScenario({required super.scenarioContext});

//   @override
//   String get name => 'Build ipa';

//   @override
//   List<ScriptStage> get stages => [
//         ReadPubspecStage(scenarioContext: scenarioContext),
//         BuildIpaStage(scenarioContext: scenarioContext),
//       ];
// }

// final class BuildIpaStage extends ScriptStage$Base {
//   BuildIpaStage({required super.scenarioContext}) : super('Build ipa');

//   @override
//   Future<bool> run({bool dryRun = true}) async {
//     final buildNumber = scenarioContext['buildNumber'] as String;
//     final versionName = scenarioContext['versionName'] as String;
//     l.i('Build ipa $versionName+$buildNumber');
//     if (!dryRun) {
//       await cmd(
//         'flutter',
//         [
//           'build',
//           'ipa',
//           '--release',
//           '--build-name=$versionName',
//           '--build-number=$buildNumber',
//           '--dart-define-from-file=config/development.json',
//           '--export-options-plist=ios/ExportOptions.plist'
//         ],
//         workingDirectory: getProjectDir(toolsWorkspace: false).path,
//       );
//     }
//     return true;
//   }
// }

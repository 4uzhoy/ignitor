import 'dart:io';

import 'package:l/l.dart';
import 'package:path/path.dart' as p;

import '../base/scenario.dart';
import '../base/script_stage.dart';
import '../common_stage.dart';
import '../utils/utils.dart';

final class BumpBuildNumberScenario extends Scenario {
  const BumpBuildNumberScenario({required super.scenarioContext});

  @override
  String get name => 'Bump build number';

  @override
  List<ScriptStage> get stages => [
        UpdatePubspecStage(scenarioContext: scenarioContext),
        UpdateProjectPbxprojStage(scenarioContext: scenarioContext),
        UpdateLocalPropertiesStage(scenarioContext: scenarioContext),
        CodgenStage(scenarioContext: scenarioContext),
      ];
}

final class UpdatePubspecStage extends ScriptStage$Base {
  late String versionName;
  late int buildNumber;

  UpdatePubspecStage({required super.scenarioContext}) : super('Обновление pubspec.yaml');

  @override
  Future<bool> run({bool dryRun = true}) async {
    final pubspec = File(p.join(getProjectDir(toolsWorkspace: false).path, 'pubspec.yaml'));
    print('pubspec: ${pubspec.path}');
    final lines = pubspec.readAsLinesSync();
    final index = lines.indexWhere((line) => line.startsWith('version:'));
    if (index == -1) return false;
    final parts = lines[index].split('+');
    versionName = parts[0].split(':')[1].trim();
    final currentBuildNumber = int.parse(parts[1].trim());
    final newBuildNumber = currentBuildNumber + 1;
    if (!dryRun) {
      lines[index] = 'version: $versionName+$newBuildNumber';
      pubspec.writeAsStringSync(lines.join('\n'));
    }
    l.i('Updated pubspec.yaml $versionName+$currentBuildNumber -> $versionName+$newBuildNumber');
    saveToContext('versionName', versionName);
    saveToContext('buildNumber', newBuildNumber.toString());
    return true;
  }
}

final class UpdateProjectPbxprojStage extends ScriptStage$Base {
  UpdateProjectPbxprojStage({required super.scenarioContext}) : super('Обновление project.pbxproj');

  @override
  Future<bool> run({bool dryRun = true}) async {
    final versionName = getOrFail<String>('versionName');
    final buildNumber = getOrFail<String>('buildNumber');

    final pbxproj =
        File(p.join(getProjectDir(toolsWorkspace: false).path, 'ios', 'Runner.xcodeproj', 'project.pbxproj'));
    if (!pbxproj.existsSync()) return false;
    var content = pbxproj.readAsStringSync();
    content = content.replaceAllMapped(
      RegExp(r'FLUTTER_BUILD_NAME = (\d+\.\d+\.\d+);'),
      (match) => 'FLUTTER_BUILD_NAME = $versionName;',
    );
    content = content.replaceAllMapped(
      RegExp(r'FLUTTER_BUILD_NUMBER = (\d+);'),
      (match) => 'FLUTTER_BUILD_NUMBER = $buildNumber;',
    );
    if (!dryRun) {
      pbxproj.writeAsStringSync(content);
    }
    l.i('Updated project.pbxproj to $versionName+$buildNumber');
    return true;
  }
}

final class UpdateLocalPropertiesStage extends ScriptStage$Base {
  UpdateLocalPropertiesStage({required super.scenarioContext}) : super('Обновление local.properties');

  @override
  Future<bool> run({bool dryRun = true}) async {
    final versionName = getOrFail<String>('versionName');
    final buildNumber = getOrFail<String>('buildNumber');
    // === Обновляем android/local.properties ===
    final androidDir = p.joinAll([p.join(getProjectDir(toolsWorkspace: false).path, 'android')]);
    final localPropertiesDir = p.joinAll([androidDir, 'local.properties']);
    final localProperties = File(localPropertiesDir);
    if (!localProperties.existsSync()) {
      l.e('local.properties not found');
      exit(1);
    }
    var localPropsContent = localProperties.readAsStringSync();

// Обновляем flutter.versionName
    localPropsContent = localPropsContent.replaceAllMapped(
      RegExp(r'flutter.versionName=.*'),
      (match) => 'flutter.versionName=$versionName',
    );

// Обновляем flutter.versionCode
    localPropsContent = localPropsContent.replaceAllMapped(
      RegExp(r'flutter.versionCode=.*'),
      (match) => 'flutter.versionCode=$buildNumber',
    );
    if (!dryRun) {
      // Записываем изменения в файл
      localProperties.writeAsStringSync(localPropsContent);
      l.i('Updated local.properties to version $versionName and build number $buildNumber');
    }

    return true;
  }
}

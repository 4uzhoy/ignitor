import 'dart:convert';
import 'dart:io';

import 'package:l/l.dart';
import 'package:path/path.dart' as p;

import 'base/script_stage.dart';
import 'utils/utils.dart';

final class CodgenStage extends ScriptStage$Base {
  const CodgenStage({required super.scenarioContext}) : super('codgen');

  @override
  Future<bool> run({bool dryRun = false}) async {
    if (dryRun) {
      l.v('Dry run script stage: $name');
      return true;
    }
    await cmd(
      'dart',
      ['run', 'build_runner', 'build', '--delete-conflicting-outputs'],
      workingDirectory: getProjectDir().path,
    );
    return true;
  }
}

final class ReadPubspecStage extends ScriptStage$Base {
  ReadPubspecStage({required super.scenarioContext}) : super('Чтение pubspec.yaml');

  @override
  Future<bool> run({bool dryRun = true}) async {
    final pubspec = File(p.join(getProjectDir().path, 'pubspec.yaml'));
    if (!pubspec.existsSync()) return false;
    final lines = pubspec.readAsLinesSync();
    final index = lines.indexWhere((line) => line.startsWith('version:'));
    if (index == -1) return false;
    final parts = lines[index].split('+');
    final versionName = parts[0].split(':')[1].trim();
    final buildNumber = parts[1].trim();
    l.i('Read pubspec.yaml $versionName+$buildNumber');
    saveToContext('versionName', versionName);
    saveToContext('buildNumber', buildNumber);
    return true;
  }
}

final class ReadConfigStage extends ScriptStage$Base {
  ReadConfigStage({required super.scenarioContext}) : super('Чтение config');

  @override
  Future<bool> run({bool dryRun = true}) async {
    final configFile = File(p.join(getProjectDir().path, '.config', 'development.json'));
    if (!configFile.existsSync()) {
      l.w('.config/development.json not found');
      return false;
    }
    final configContent = await configFile.readAsString();
    final config = jsonDecode(configContent) as Map<String, dynamic>;
    saveToContext('config', config);
    l.i('Read config from .config/development.json');
    return true;
  }
}

final class ReadChangelogStage extends ScriptStage$Base {
  ReadChangelogStage({required super.scenarioContext}) : super('Чтение CHANGELOG.md');

  @override
  Future<bool> run({bool dryRun = true}) async {
    final versionName = scenarioContext['versionName'] as String;
    final changelog = File(p.join(getProjectDir().path, 'CHANGELOG.md'));
    if (!changelog.existsSync()) {
      l.e('CHANGELOG.md not found');
      return false;
    }
    final lines = changelog.readAsLinesSync();
    final versionIndex = lines.indexWhere((element) => element.contains('[$versionName]'));
    if (versionIndex == -1) {
      l.e('Version [$versionName] not found in CHANGELOG.md');
      return false;
    }

    // Найти следующий разделитель --- после текущей версии
    final endOfVersionChangelog = lines.indexWhere(
      (element) => element.trim() == '---',
      versionIndex + 1,
    );
    if (endOfVersionChangelog == -1) {
      l.e('End marker --- not found after version [$versionName]');
      return false;
    }

    final changelogLines = lines.sublist(versionIndex, endOfVersionChangelog);
    final changelogString = changelogLines.join('\n');
    saveToContext('changelogString', changelogString);
    l.i('Read changelog for version [$versionName], ${changelogLines.length} lines');
    return true;
  }
}

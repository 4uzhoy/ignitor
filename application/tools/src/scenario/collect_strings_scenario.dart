import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import '../base/scenario.dart';
import '../base/script_stage.dart';
import '../stage/save_to_file_stage.dart';
import '../utils/utils.dart';

final class CollectStringsScenario extends Scenario {
  const CollectStringsScenario({required super.scenarioContext});

  @override
  String get name => 'Collect strings from app';

  @override
  List<ScriptStage> get stages => [
        CollectStrings(scenarioContext: scenarioContext),
        // MergeStrings(scenarioContext: scenarioContext),
      ];
}

final class CollectStrings extends ScriptStage$Base {
  CollectStrings({required super.scenarioContext}) : super('Сбор строк в приложении');

  @override
  Future<bool> run({bool dryRun = true}) async {
    final projectDirectory = getProjectDir(toolsWorkspace: false);
    final libDirectory = Directory(path.join(projectDirectory.path, 'lib'));
    final srcDirectory = Directory(path.join(libDirectory.path, 'src'));

    final files = srcDirectory.listSync(recursive: true, followLinks: false).where(
          (entity) =>
              entity is File &&
              entity.path.endsWith('.dart') &&
              !entity.path.contains(
                RegExp(
                  '''l10n|news_viewer_model|detailed_values_dialog|call_rate_dialog_panel|task_dashboard|repository|developer|debug|test|mock''',
                ),
              ) &&
              entity.path.contains(
                RegExp(
                  '''widgets|widget|page|pages''',
                ),
              ),
        );

    final stringPattern = RegExp(
      r"(?<!\/\/.*)'[^'\\]*(?:\\.[^'\\]*)*[\u0400-\u04FF][^'\\]*(?:\\.[^'\\]*)*'",
    );

    final Map<String, List<Map<String, String>>> fileStringMap = {};

    for (final entity in files) {
      final file = entity as File;
      final relativePath = path.relative(file.path, from: projectDirectory.path);
      final fileName = path.basenameWithoutExtension(file.path); // e.g., custom_app_bar
      final lines = file.readAsLinesSync();

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (!isLoggerOrDocs(line) && !isRegExp(line) && !isAssert(line)) {
          final matches = stringPattern.allMatches(line);
          for (final match in matches) {
            fileStringMap.putIfAbsent(fileName, () => []).add({
              'line': '$relativePath:${i + 1}',
              'src': match.group(0)!,
            });
          }
        }
      }
    }

    final outputBaseDir = Directory('results/strings');
    if (!outputBaseDir.existsSync()) {
      outputBaseDir.createSync(recursive: true);
    }

    final jsonEncoder = JsonEncoder.withIndent('  ');

    for (final entry in fileStringMap.entries) {
      final fileName = entry.key;
      final entries = entry.value;

      if (entries.isEmpty) continue;

      // Используем путь первой строки для определения фичи
      final firstPath = entries.first['line']!;
      final parts = path.split(firstPath);

      int featureIndex = parts.indexOf('feature');
      String featureName;
      if (featureIndex != -1 && featureIndex + 1 < parts.length) {
        featureName = parts[featureIndex + 1];
      } else {
        featureName = 'common';
      }

      final content = jsonEncoder.convert(entries);

      // Используем общий stage для сохранения
      final saveStage = SaveToFileStage(
        scenarioContext: scenarioContext,
        relativePath: 'strings/$featureName',
        fileName: '$fileName.json',
        content: content,
      );
      await saveStage.run(dryRun: dryRun);
    }

    return true;
  }

  bool isLoggerOrDocs(String line) {
    return line.contains(
      RegExp(
        r'\/\/\//|\/\/|logger\.(i|d|e|w|v|wtf)|l\.(i|d|e|w|v|wtf)|\.\.(i|d|e|w|v|wtf)',
      ),
    );
  }

  bool isAssert(String line) {
    return line.contains('assert');
  }

  bool isRegExp(String line) {
    return line.contains('RegExp(') || line.contains('^');
  }
}

final class MergeStrings extends ScriptStage$Base {
  late String versionName;
  late int buildNumber;

  MergeStrings({required super.scenarioContext}) : super('Форматирование собранных строк');

  @override
  Future<bool> run({bool dryRun = true}) async {
    // Чтение исходного JSON-файла
    final inputFile = File('results/found_strings.json');
    final jsonString = inputFile.readAsStringSync();
    final inputJson = jsonDecode(jsonString) as List<dynamic>;

    final result = <Map<String, dynamic>>[];
    Map<String, dynamic>? lastItem;

    // Обработка JSON-объектов
    for (final item in inputJson) {
      final currentItem = item as Map<String, dynamic>;

      if (lastItem != null && canBeCombined(lastItem, currentItem)) {
        lastItem['src'] =
            "${lastItem['src']!.replaceAll("'", '')} ${(currentItem['src'] as String).replaceAll("'", '')}";
        lastItem['lines'].add(int.parse((currentItem['line'] as String).split(':').last));
      } else {
        if (lastItem != null) {
          result.add(lastItem);
        }
        lastItem = <String, dynamic>{
          'file': currentItem['line']!.split(':')[0],
          'lines': [int.parse((currentItem['line'] as String).split(':')[1])],
          'src': currentItem['src']!,
          'output': currentItem['output'],
        };
      }
    }

    if (lastItem != null) {
      result.add(lastItem);
    }

    // Сохранение обработанного JSON-файла
    const jsonEncoder = JsonEncoder.withIndent('  ');
    final jsonStringOutput = jsonEncoder.convert(result);
    final outputFile = File('results/processed_strings.json');
    outputFile.writeAsStringSync(jsonStringOutput);

    print('Processed strings saved to processed_strings.json');
    return true;
  }

  bool canBeCombined(Map<String, dynamic> item1, Map<String, dynamic> item2) {
    final path1 = item1['file'] as String;
    final line1 = (item1['lines'] as List<int>).last;

    final path2 = (item2['line'] as String).split(':')[0];
    final line2 = int.parse((item2['line'] as String).split(':')[1]);

    return path1 == path2 && line2 == line1 + 1;
  }
}

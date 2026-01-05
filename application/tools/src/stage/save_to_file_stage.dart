import 'dart:io';

import 'package:path/path.dart' as path;

import '../base/script_stage.dart';

/// Общий stage для сохранения контента в файл.
/// Автоматически создает необходимые директории.
final class SaveToFileStage extends ScriptStage$Base {
  SaveToFileStage({
    required super.scenarioContext,
    required this.relativePath,
    required this.fileName,
    required this.content,
    this.baseDir = 'results',
  }) : super('Сохранение файла $fileName');

  /// Базовая директория (по умолчанию 'results' относительно директории tools)
  final String baseDir;

  /// Относительный путь внутри baseDir (например, 'git_history', 'strings')
  final String relativePath;

  /// Имя файла с расширением
  final String fileName;

  /// Контент для сохранения
  final String content;

  @override
  Future<bool> run({bool dryRun = true}) async {
    try {
      final outputDir = Directory(path.join(baseDir, relativePath));
      if (!outputDir.existsSync()) {
        if (!dryRun) {
          outputDir.createSync(recursive: true);
        }
      }

      final outputFile = File(path.join(outputDir.path, fileName));

      if (dryRun) {
        return true;
      }

      await outputFile.writeAsString(content);
      return true;
    } catch (e) {
      return false;
    }
  }
}

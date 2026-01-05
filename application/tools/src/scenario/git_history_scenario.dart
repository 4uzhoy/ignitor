import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:l/l.dart';

import '../base/scenario.dart';
import '../base/script_stage.dart';
import '../stage/save_to_file_stage.dart';

/// Сценарий для генерации отчета git history за месяц
final class GitHistoryScenario extends Scenario {
  const GitHistoryScenario({required super.scenarioContext});

  @override
  String get name => 'Git History Report';

  @override
  List<ScriptStage> get stages => [
        CollectGitLog(scenarioContext: scenarioContext),
        ProcessGitLog(scenarioContext: scenarioContext),
        SaveGitHistory(scenarioContext: scenarioContext),
      ];
}

/// Stage для сбора git log за указанный месяц
final class CollectGitLog extends ScriptStage$Base {
  CollectGitLog({required super.scenarioContext}) : super('Сбор git log');

  @override
  Future<bool> run({bool dryRun = true}) async {
    try {
      // Получаем дату из контекста или используем текущую
      final DateTime targetDate = scenarioContext['targetDate'] as DateTime? ?? DateTime.now();

      final firstDay = DateTime(targetDate.year, targetDate.month, 1);
      final lastDay = DateTime(targetDate.year, targetDate.month + 1, 0);

      final dateFormat = DateFormat('yyyy-MM-dd');
      final sinceDate = dateFormat.format(firstDay);
      final untilDate = dateFormat.format(lastDay);

      if (dryRun) {
        saveToContext('gitLogOutput', '');
        saveToContext('targetDate', targetDate);
        return true;
      }

      // Выполнение команды git log
      final result = await Process.run(
        'git',
        [
          'log',
          '--since=$sinceDate',
          '--until=$untilDate',
          '--pretty=format:%h|%an|%s|%cd',
          '--shortstat',
          '--date=format:%a, %d.%m.%Y %H:%M',
        ],
      );

      if (result.exitCode == 0) {
        saveToContext('gitLogOutput', result.stdout as String);
        saveToContext('targetDate', targetDate);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

/// Stage для обработки git log и форматирования в Markdown
final class ProcessGitLog extends ScriptStage$Base {
  ProcessGitLog({required super.scenarioContext}) : super('Обработка git log');

  @override
  Future<bool> run({bool dryRun = true}) async {
    try {
      final gitLogOutput = getOrFail<String>('gitLogOutput');
      final targetDate = getOrFail<DateTime>('targetDate');

      if (dryRun) {
        saveToContext('markdownContent', '');
        return true;
      }

      final markdownContent = _processGitLog(gitLogOutput, targetDate);
      saveToContext('markdownContent', markdownContent);
      return true;
    } catch (e, stackTrace) {
      l.e('Ошибка обработки git log: $e');
      l.e('StackTrace: $stackTrace');
      return false;
    }
  }

  String _processGitLog(String gitLog, DateTime targetDate) {
    final lines = LineSplitter.split(gitLog).toList();
    final dateFormat = DateFormat('dd.MM.yyyy');
    final monthName = DateFormat.MMMM().format(targetDate); // Используем дефолтную локаль

    final buffer = StringBuffer();
    buffer.writeln('# Коммиты за $monthName ${targetDate.year}');
    buffer.writeln();

    String currentDay = '';
    final dailyCommits = <String, Map<String, dynamic>>{};
    List<Map<String, dynamic>> commitsForDay = [];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      if (line.contains('|')) {
        final parts = line.split('|').map((e) => e.trim()).toList();

        if (parts.length >= 4) {
          final commitHash = parts[0];
          final author = parts[1];
          final commitMessage = parts[2];
          final commitDateStr = parts[3];

          final commitDateParsed = DateFormat('EEE, dd.MM.yyyy HH:mm', 'en_US').parse(commitDateStr);
          final commitDay = dateFormat.format(commitDateParsed);
          final commitTime = DateFormat('HH:mm').format(commitDateParsed);

          if (commitDay != currentDay) {
            if (currentDay != '') {
              _appendDayInfo(buffer, currentDay, dailyCommits);
            }

            currentDay = commitDay;
            commitsForDay = [];
            dailyCommits[currentDay] = {
              'commits': commitsForDay,
              'totalFiles': 0,
              'totalInsertions': 0,
              'totalDeletions': 0,
            };
          }

          int filesChanged = 0;
          int insertions = 0;
          int deletions = 0;

          if (i + 1 < lines.length && lines[i + 1].contains('changed')) {
            final stats = _parseShortStat(lines[i + 1]);
            filesChanged = stats['files'] ?? 0;
            insertions = stats['insertions'] ?? 0;
            deletions = stats['deletions'] ?? 0;
            i++;
          }

          dailyCommits[currentDay]!['totalFiles'] += filesChanged;
          dailyCommits[currentDay]!['totalInsertions'] += insertions;
          dailyCommits[currentDay]!['totalDeletions'] += deletions;

          dailyCommits[currentDay]!['commits'].add({
            'hash': commitHash,
            'author': author,
            'message': commitMessage,
            'date': commitDateStr,
            'time': commitTime,
            'filesChanged': filesChanged,
            'insertions': insertions,
            'deletions': deletions,
          });
        }
      }
    }

    if (currentDay != '') {
      _appendDayInfo(buffer, currentDay, dailyCommits);
    }

    return buffer.toString();
  }

  void _appendDayInfo(StringBuffer buffer, String day, Map<String, Map<String, dynamic>> dailyCommits) {
    final dayInfo = dailyCommits[day]!;
    buffer.writeln(
        '### $day | ${dayInfo['commits'].length} коммитов | ${dayInfo['totalFiles']} files. ${dayInfo['totalInsertions']}(+), ${dayInfo['totalDeletions']}(-)');

    for (final commit in dayInfo['commits']) {
      buffer.writeln(
          '* ${commit['time']} ${commit['author']}: ${commit['message']} (${commit['filesChanged']} files. ${commit['insertions']}(+), ${commit['deletions']}(-))');
    }
    buffer.writeln();
  }

  Map<String, int> _parseShortStat(String statLine) {
    final stats = <String, int>{};

    final fileChangeMatch = RegExp(r'(\d+) file[s]? changed').firstMatch(statLine);
    if (fileChangeMatch != null) {
      stats['files'] = int.parse(fileChangeMatch.group(1)!);
    }

    final insertionsMatch = RegExp(r'(\d+) insertion[s]?\(\+\)').firstMatch(statLine);
    if (insertionsMatch != null) {
      stats['insertions'] = int.parse(insertionsMatch.group(1)!);
    }

    final deletionsMatch = RegExp(r'(\d+) deletion[s]?\(-\)').firstMatch(statLine);
    if (deletionsMatch != null) {
      stats['deletions'] = int.parse(deletionsMatch.group(1)!);
    }

    return stats;
  }
}

/// Stage для сохранения git history в файл
final class SaveGitHistory extends ScriptStage$Base {
  SaveGitHistory({required super.scenarioContext}) : super('Сохранение git history');

  @override
  Future<bool> run({bool dryRun = true}) async {
    try {
      final markdownContent = getOrFail<String>('markdownContent');
      final targetDate = getOrFail<DateTime>('targetDate');

      final fileName = 'git_log_${targetDate.year}_${targetDate.month}.md';

      final saveStage = SaveToFileStage(
        scenarioContext: scenarioContext,
        relativePath: 'git_history',
        fileName: fileName,
        content: markdownContent,
      );

      return await saveStage.run(dryRun: dryRun);
    } catch (e, stackTrace) {
      l.e('Ошибка сохранения git history: $e');
      l.e('StackTrace: $stackTrace');
      return false;
    }
  }
}

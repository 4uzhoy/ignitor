// // ignore_for_file: unused_local_variable

// import 'dart:convert';
// import 'dart:io';

// import 'package:intl/intl.dart';
// import 'package:l/l.dart';

// /// * .🟢 - Half day
// /// * .🟡 - Full day (🟢+🟢)
// void main() async {
//   DateTime? setted;
//   setted = DateTime(2025, 09, 1);
//   // Определение текущего месяца и года
//   final now = setted;
//   final firstDay = DateTime(now.year, now.month, 1);
//   final lastDay = DateTime(now.year, now.month + 1, 0);

//   // Форматирование дат для команды
//   final dateFormat = DateFormat('yyyy-MM-dd');
//   final sinceDate = dateFormat.format(firstDay);
//   final untilDate = dateFormat.format(lastDay);

//   // Выполнение команды git log
//   final result = await Process.run(
//     'git',
//     [
//       'log',
//       '--since=$sinceDate',
//       '--until=$untilDate',
//       '--pretty=format:%h|%an|%s|%cd',
//       '--shortstat',
//       '--date=format:%a, %d.%m.%Y %H:%M'
//     ],
//   );

//   if (result.exitCode == 0) {
//     // Сохранение результата в файл .md
//     String baseFileName = 'git_log_${now.year}_${now.month}';
//     String extension = '.md';
//     String fileName = '$baseFileName$extension';
//     File outputFile = File(fileName);

//     int counter = 1;
//     while (outputFile.existsSync()) {
//       fileName = '$baseFileName($counter)$extension';
//       outputFile = File(fileName);
//       counter++;
//     }

//     final content = processGitLog(result.stdout as String, now);
//     await outputFile.writeAsString(content);
//     l.i('Git log сохранен в файл: ${outputFile.path}');
//   } else {
//     l.e('Ошибка выполнения команды git log: ${result.stderr}');
//   }
// }

// // Функция для обработки git log и формирования Markdown содержимого
// String processGitLog(String gitLog, DateTime now) {
//   final lines = LineSplitter.split(gitLog).toList();
//   final dateFormat = DateFormat('dd.MM.yyyy');
//   final monthName = DateFormat.MMMM().format(now); // Название месяца

//   // Буфер для Markdown-таблицы
//   final buffer = StringBuffer();
//   buffer.writeln('# Коммиты за $monthName ${now.year}');
//   buffer.writeln();

//   // Переменные для текущего дня
//   String currentDay = '';
//   int dayCommits = 0;

//   // Мапа для хранения статистики по каждому дню
//   final dailyCommits = <String, Map<String, dynamic>>{};

//   // Список коммитов для текущего дня
//   List<Map<String, dynamic>> commitsForDay = [];

//   // Парсинг данных по дням
//   for (int i = 0; i < lines.length; i++) {
//     final line = lines[i];

//     if (line.contains('|')) {
//       final parts = line.split('|').map((e) => e.trim()).toList();

//       if (parts.length >= 4) {
//         final commitHash = parts[0];
//         final author = parts[1];
//         final commitMessage = parts[2];
//         final commitDateStr = parts[3];

//         // Парсинг даты коммита
//         final commitDateParsed = DateFormat('EEE, dd.MM.yyyy HH:mm', 'en_US').parse(commitDateStr);
//         final commitDay = dateFormat.format(commitDateParsed);
//         final commitTime = DateFormat('HH:mm').format(commitDateParsed);

//         // Если день поменялся, сохраняем предыдущий день и начинаем новый
//         if (commitDay != currentDay) {
//           if (currentDay != '') {
//             // Добавляем информацию о предыдущем дне в buffer
//             final dayInfo = dailyCommits[currentDay]!;
//             buffer.writeln(
//                 '### $currentDay | ${dayInfo['commits'].length} коммитов | ${dayInfo['totalFiles']} files. ${dayInfo['totalInsertions']}(+), ${dayInfo['totalDeletions']}(-)');

//             for (final commit in dayInfo['commits']) {
//               buffer.writeln(
//                   '* ${commit['time']} ${commit['author']}: ${commit['message']} (${commit['filesChanged']} files. ${commit['insertions']}(+), ${commit['deletions']}(-))');
//             }
//             buffer.writeln();
//           }

//           // Начинаем новый день
//           currentDay = commitDay;
//           dayCommits = 0;
//           commitsForDay = [];
//           dailyCommits[currentDay] = {
//             'commits': commitsForDay,
//             'totalFiles': 0,
//             'totalInsertions': 0,
//             'totalDeletions': 0,
//           };
//         }

//         // Сбор информации о файлах, вставках и удалениях
//         int filesChanged = 0;
//         int insertions = 0;
//         int deletions = 0;

//         if (i + 1 < lines.length && lines[i + 1].contains('changed')) {
//           final stats = _parseShortStat(lines[i + 1]);
//           filesChanged = stats['files'] ?? 0;
//           insertions = stats['insertions'] ?? 0;
//           deletions = stats['deletions'] ?? 0;

//           i++; // Пропустить строку с изменениями файлов
//         }

//         // Обновляем статистику дня
//         dayCommits++;
//         dailyCommits[currentDay]!['totalFiles'] += filesChanged;
//         dailyCommits[currentDay]!['totalInsertions'] += insertions;
//         dailyCommits[currentDay]!['totalDeletions'] += deletions;

//         // Сохранение данных коммита
//         dailyCommits[currentDay]!['commits'].add({
//           'hash': commitHash,
//           'author': author,
//           'message': commitMessage,
//           'date': commitDateStr,
//           'time': commitTime,
//           'filesChanged': filesChanged,
//           'insertions': insertions,
//           'deletions': deletions,
//         });
//       }
//     }
//   }

//   // Добавляем информацию о последнем дне
//   if (currentDay != '') {
//     final dayInfo = dailyCommits[currentDay]!;
//     buffer.writeln(
//         '### $currentDay | ${dayInfo['commits'].length} коммитов | ${dayInfo['totalFiles']} files. ${dayInfo['totalInsertions']}(+), ${dayInfo['totalDeletions']}(-)');

//     for (final commit in dayInfo['commits']) {
//       buffer.writeln(
//           '* ${commit['time']} ${commit['author']}: ${commit['message']} (${commit['filesChanged']} files. ${commit['insertions']}(+), ${commit['deletions']}(-))');
//     }
//     buffer.writeln();
//   }

//   return buffer.toString();
// }

// // Функция для парсинга строки с краткой статистикой
// Map<String, int> _parseShortStat(String statLine) {
//   final stats = <String, int>{};

//   final fileChangeMatch = RegExp(r'(\d+) file[s]? changed').firstMatch(statLine);
//   if (fileChangeMatch != null) {
//     stats['files'] = int.parse(fileChangeMatch.group(1)!);
//   }

//   final insertionsMatch = RegExp(r'(\d+) insertion[s]?\(\+\)').firstMatch(statLine);
//   if (insertionsMatch != null) {
//     stats['insertions'] = int.parse(insertionsMatch.group(1)!);
//   }

//   final deletionsMatch = RegExp(r'(\d+) deletion[s]?\(-\)').firstMatch(statLine);
//   if (deletionsMatch != null) {
//     stats['deletions'] = int.parse(deletionsMatch.group(1)!);
//   }

//   return stats;
// }

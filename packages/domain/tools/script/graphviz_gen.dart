// ignore_for_file: avoid_print

import 'dart:io';

import 'entity_class.dart';

void main() async {
  final entities = <EntityClass>[];
  final repositories = <EntityClass>[];

  // Сканируем директории
  final searchDirs = [Directory('lib/src/model'), Directory('lib/src/repositories')];
  for (final dir in searchDirs) {
    if (!dir.existsSync()) continue;
    await for (final file in dir.list(recursive: true)) {
      if (file is File && file.path.endsWith('.dart')) {
        final content = await file.readAsString();
        final entity = parseEntityClass(content);
        if (entity != null) {
          if (file.path.contains('repositories')) {
            repositories.add(entity);
          } else {
            entities.add(entity);
          }
        }
      }
    }
  }

  final dot = generateDot(entities, repositories);
  final output = File('diagram.dot');
  await output.writeAsString(dot);

  print('✅ Graphviz .dot диаграмма сохранена в diagram.dot');
}

EntityClass? parseEntityClass(String content) {
  final classRegex = RegExp(r'(abstract\s+interface\s+class|class|abstract\s+class)\s+(\w+)(?:\s+extends\s+\S+)?');
  final match = classRegex.firstMatch(content);
  if (match == null) return null;

  final className = match.group(2)!;
  final fields = <EntityField>[];
  final methods = <String>[];

  // Захватываем все поля: final, var, late final, late var, const
  final fieldRegex = RegExp(r'(?:final|var|late final|late var|late|const)?\s*(\S+)\s+(\w+);');
  for (final match in fieldRegex.allMatches(content)) {
    final type = match.group(1)!;
    final name = match.group(2)!;
    final isNullable = type.endsWith('?');
    fields.add(EntityField(name: name, type: type, isNullable: isNullable));
  }

  // Методы с возвращаемым типом
  final methodRegex = RegExp(r'(\w+(?:<\S+>)?)\s+(\w+)\([^)]*\)');
  for (final match in methodRegex.allMatches(content)) {
    final returnType = match.group(1)!;
    final methodName = match.group(2)!;
    methods.add('$returnType $methodName()');
  }

  return EntityClass(name: className, fields: fields, methods: methods);
}

String generateDot(List<EntityClass> entities, List<EntityClass> repositories) {
  final buffer =
      StringBuffer()
        ..writeln('digraph G {')
        ..writeln('  rankdir=TB;')
        ..writeln('  node [shape=plaintext, fontname="Arial", fontsize=16];');

  final colors = [
    '#c8e6c9',
    '#b3e5fc',
    '#fff9c4',
    '#ffe0b2',
    '#f8bbd0',
    '#d1c4e9',
    '#b2dfdb',
    '#bbdefb',
    '#ffcdd2',
    '#c5cae9',
  ];

  var colorIndex = 0;

  // Репозитории
  final repoNames = repositories.map((r) => r.name).toList();
  for (final repo in repositories) {
    final color = colors[colorIndex % colors.length];
    colorIndex++;
    buffer
      ..writeln('  ${repo.name} [label=<')
      ..writeln('    <TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0" BGCOLOR="$color">')
      ..writeln('      <TR><TD><B>${repo.name}</B></TD></TR>');
    for (final method in repo.methods) {
      buffer.writeln('      <TR><TD ALIGN="LEFT">+ $method</TD></TR>');
    }
    buffer
      ..writeln('    </TABLE>')
      ..writeln('  >];');
  }
  buffer.writeln('  { rank=same; ${repoNames.join('; ')}; }');

  // Сущности
  final entityNames = entities.map((e) => e.name).toList();
  for (final entity in entities) {
    final color = colors[colorIndex % colors.length];
    colorIndex++;
    buffer
      ..writeln('  ${entity.name} [label=<')
      ..writeln('    <TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0" BGCOLOR="$color">')
      ..writeln('      <TR><TD><B>${entity.name}</B></TD></TR>');
    for (final field in entity.fields) {
      buffer.writeln('      <TR><TD ALIGN="LEFT">${field.type} ${field.name}</TD></TR>');
    }
    for (final method in entity.methods) {
      buffer.writeln('      <TR><TD ALIGN="LEFT">+ $method</TD></TR>');
    }
    buffer
      ..writeln('    </TABLE>')
      ..writeln('  >];');
  }
  buffer.writeln('  { rank=same; ${entityNames.join('; ')}; }');

  // Связи
  for (final entity in entities) {
    for (final field in entity.fields) {
      final targetClass =
          field.type.replaceAll('?', '').replaceAll('List<', '').replaceAll('>', '').replaceAll('Entities<', '').trim();
      if (entities.any((e) => e.name == targetClass)) {
        buffer.writeln('  ${entity.name} -> $targetClass [arrowhead=vee];');
      }
    }
  }

  buffer.writeln('}');
  return buffer.toString();
}

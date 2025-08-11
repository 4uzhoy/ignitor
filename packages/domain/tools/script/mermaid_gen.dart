import 'dart:io';

import 'entity_class.dart';

void main() async {
  final entities = <EntityClass>[];

  final modelDir = Directory('lib/src/model');
  if (modelDir.existsSync()) {
    await for (final file in modelDir.list(recursive: true)) {
      if (file is File && file.path.endsWith('.dart')) {
        final content = await file.readAsString();
        final entity = parseEntityClass(content);
        if (entity != null) {
          entities.add(entity);
        }
      }
    }
  }

  final mermaid = generateMermaidERDiagram(entities);
  if (!Directory('doc/diagram').existsSync()) {
    Directory('doc/diagram').createSync(recursive: true);
  }
  final output = File('doc/diagram/mermaid_entities.md');
  await output.writeAsString(mermaid);
  stdout.writeln(
    '✅ Mermaid erDiagram saved in doc/diagram/mermaid_entities.md',
  );
}

EntityClass? parseEntityClass(String content) {
  final classRegex = RegExp(
    r'(class|abstract\s+class)\s+(\w+)(?:\s+extends\s+\S+)?',
  );
  final match = classRegex.firstMatch(content);
  if (match == null) return null;

  final className = match.group(2)!;
  final fields = <EntityField>[];

  final fieldRegex = RegExp(
    r'^\s*(?:final|var|late final|late var|late|const)?\s*(\S+)\s+(\w+);',
    multiLine: true,
  );
  for (final match in fieldRegex.allMatches(content)) {
    final type = match.group(1)!;
    final name = match.group(2)!;
    final isNullable = type.endsWith('?');
    final cleanedType = type.replaceAll('?', '');
    fields.add(
      EntityField(name: name, type: cleanedType, isNullable: isNullable),
    );
  }

  return EntityClass(name: className, fields: fields, methods: []);
}

String generateMermaidERDiagram(List<EntityClass> entities) {
  final buffer = StringBuffer();

  buffer.writeln('```mermaid');
  buffer.writeln('erDiagram');

  for (final entity in entities) {
    final entityIdType = '${entity.name.replaceAll('Entity', '')}ID';
    buffer.writeln('  ${entity.name} {');
    buffer.writeln('    $entityIdType id');

    for (final field in entity.fields) {
      final type = _mapTypeToMermaid(field.type);
      final nullableSuffix = field.isNullable ? '(nullable)' : '';
      buffer.writeln('    $type$nullableSuffix ${field.name}');
    }

    buffer.writeln('  }');
  }

  // connections
  for (final entity in entities) {
    for (final field in entity.fields) {
      final targetClass =
          field.type
              .replaceAll('List<', '')
              .replaceAll('Entities<', '')
              .replaceAll('>', '')
              .trim();

      if (entities.any((e) => e.name == targetClass)) {
        buffer.writeln('  ${entity.name} }|..|{ $targetClass : "связь"');
      }
    }
  }

  buffer.writeln('```');
  return buffer.toString();
}

String _mapTypeToMermaid(String type) {
  if (type.contains('int')) return 'int';
  if (type.contains('double') || type.contains('num')) return 'float';
  if (type.contains('DateTime')) return 'datetime';
  if (type.contains('bool')) return 'boolean';
  if (type.contains('String')) return 'string';
  if (type.contains('Entities')) {
    final innerType = type.substring(type.indexOf('<') + 1, type.indexOf('>'));
    return '$innerType[]';
  }
  if (type.contains('List<')) {
    final innerType = type.substring(type.indexOf('<') + 1, type.indexOf('>'));
    return '$innerType[---]';
  }
  return type;
}

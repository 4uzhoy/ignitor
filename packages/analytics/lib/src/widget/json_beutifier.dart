import 'package:flutter/material.dart';

class GenericJsonBeautifier extends StatelessWidget {
  final dynamic json; // Поддержка как Map, так и List
  final Map<String, dynamic>? map;
  const GenericJsonBeautifier({required this.json, this.map, super.key});

  @override
  Widget build(BuildContext context) => RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16, color: Colors.black), // Общий стиль текста
          children: _buildJsonOrListText(json ?? map, 0), // Начальный уровень вложенности
        ),
      );

  // Проверка верхнего уровня: Map или List
  // ignore: avoid_annotating_with_dynamic
  List<TextSpan> _buildJsonOrListText(dynamic data, int level) {
    if (data is Map<String, dynamic>) {
      return _buildJsonText(data, level);
    } else if (data is List) {
      return _buildListSpan(data, level);
    } else {
      return [];
    }
  }

  // Строим текст JSON с отступами и изменением цвета на основе уровня вложенности
  List<TextSpan> _buildJsonText(Map<String, dynamic> json, int level) {
    final spans = <TextSpan>[];
    final indent = '  ' * level; // Отступ для ключей и значений на основе уровня вложенности

    // Цвета для уровней (можно добавить больше цветов при необходимости)
    final colors = <Color>[Colors.blue, Colors.orange, Colors.green, Colors.purple, Colors.pink];

    json.forEach((key, value) {
      // Определяем цвет на основе уровня вложенности
      final keyColor = colors[level % colors.length];

      // Добавляем ключ с нужным отступом и цветом
      spans.add(
        TextSpan(
          text: '$indent"$key": ',
          style: TextStyle(color: keyColor, fontWeight: FontWeight.bold),
        ),
      );

      // Обработка вложенных объектов
      if (value is Map<String, dynamic>) {
        spans
          ..add(const TextSpan(text: '{\n', style: TextStyle(color: Colors.black)))
          ..addAll(_buildJsonText(value, level + 1)) // Увеличиваем уровень вложенности
          ..add(TextSpan(text: '$indent},\n', style: const TextStyle(color: Colors.black)));
      }
      // Обработка списка
      else if (value is List) {
        spans
          ..add(const TextSpan(text: '[\n', style: TextStyle(color: Colors.black)))
          ..addAll(_buildListSpan(value, level + 1)) // Увеличиваем уровень вложенности
          ..add(TextSpan(text: '$indent],\n', style: const TextStyle(color: Colors.black)));
      }
      // Обработка простого значения
      else {
        spans.add(
          TextSpan(
            text: '"$value",\n',
            style: const TextStyle(color: Colors.green),
          ),
        );
      }
    });

    return spans;
  }

  // Обработка списка значений с отступами
  List<TextSpan> _buildListSpan(List<dynamic> list, int level) {
    final spans = <TextSpan>[];
    final indent = '  ' * level; // Отступ для элементов списка

    for (final item in list) {
      if (item is Map<String, dynamic>) {
        spans
          ..add(TextSpan(text: '$indent{\n', style: const TextStyle(color: Colors.black)))
          ..addAll(_buildJsonText(item, level + 1)) // Увеличиваем уровень вложенности
          ..add(TextSpan(text: '$indent},\n', style: const TextStyle(color: Colors.black)));
      } else if (item is List) {
        spans
          ..add(TextSpan(text: '$indent[\n', style: const TextStyle(color: Colors.black)))
          ..addAll(_buildListSpan(item, level + 1)) // Рекурсия для вложенных списков
          ..add(TextSpan(text: '$indent],\n', style: const TextStyle(color: Colors.black)));
      } else {
        spans.add(
          TextSpan(
            text: '$indent"$item",\n',
            style: const TextStyle(color: Colors.green),
          ),
        );
      }
    }

    return spans;
  }
}

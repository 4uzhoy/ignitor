import 'package:uuid/uuid.dart';

const _undefined = 'UN';

extension StringX on String {
  /// Обрезать Uuid вида `abcda-dbasdasd-asdasdasd` до `ABCDA`
  /// если uuid не валдиный вернуть строку как есть
  /// [limit] - количество символов для обрезки
  /// пример: `abcde-fghij-klmno` с limit = 3 вернет `ABC`
  String splitUuid([final int limit = 4]) {
    var lim = limit;
    // safety check
    lim = limit > length ? length : limit;
    if (Uuid.isValidUUID(fromString: this) && contains('-')) {
      return substring(0, indexOf('-')).toUpperCase().substring(0, lim);
    } else {
      return this;
    }
  }

  /// Если длина строки меньше чем [splitLength] вернуть строку как есть
  /// Если длина строки больше чем [splitLength]
  ///  вернуть строку обрезанную до [splitLength] и добавить `...`
  /// ```dart
  /// 'abcdefg'.splitTo(4); // 'abcd...'
  /// 'abc'.splitTo(4); // 'abc'
  /// ```
  String splitTo(int splitLength) {
    if (length > splitLength) {
      return '${substring(0, splitLength)}...';
    } else {
      return this;
    }
  }

  /// Вытащить первые две буквы первого слова, на любом языке, где это возможно
  /// Если буква лишь одна то вернуть Букву и точку
  /// Если нет совпадений вернуть 'un.'
  /// Если строка null вернуть 'un.'
  /// [capitalize] - если true то вернуть в верхнем регистре
  String extractFirstTwoLetter({bool capitalize = false}) {
    var result = _undefined; //undefined

    /// Позволяет взять любую букву любого алфавита
    final regex = RegExp(r'\p{Letter}', unicode: true);
    final matches = regex.allMatches(this).map((match) => match.group(0)!).toList();

    if (matches.length >= 2) {
      result = matches[0] + matches[1];
    } else if (matches.length == 1) {
      result = '${matches[0]}.';
    }

    return capitalize ? result.toUpperCase() : result;
  }
}

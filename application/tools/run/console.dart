void main(List<String> args) {
  final DateTime now = DateTime.now();
  final DateTime addedNow = now.add(const Duration(days: 1));
  final isBefore = isBeforeOrSameDay(addedNow);
  print(isBefore);
}

/// Checks if the given date is before or the same day as today.
bool isBeforeOrSameDay(DateTime date) {
  final now = DateTime.now();
  return date.year < now.year ||
      (date.year == now.year && date.month < now.month) ||
      (date.year == now.year && date.month == now.month && date.day <= now.day);
}

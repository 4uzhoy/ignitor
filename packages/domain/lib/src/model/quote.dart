import 'package:domain/domain.dart';

final class QuoteEntity extends Entity<QuoteEntity> {
  const QuoteEntity({
    required this.text,
    required this.author,
    required super.id,
  });
  final String text;
  final String author;
}

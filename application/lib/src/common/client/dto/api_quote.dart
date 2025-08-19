import 'package:json_annotation/json_annotation.dart';

part 'api_quote.g.dart';

@JsonSerializable(createToJson: false, explicitToJson: false)
class ApiQuote {
  final int id;
  final String quote;
  final String author;

  ApiQuote({required this.id, required this.quote, required this.author});

  factory ApiQuote.fromJson(Map<String, dynamic> json) =>
      _$ApiQuoteFromJson(json);
}

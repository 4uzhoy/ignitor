import 'package:domain/src/model/quote.dart';

abstract class QuotesRepository {
  /// Fetches a list of quotes.
  Future<List<QuoteEntity>> fetchQuotes();
}

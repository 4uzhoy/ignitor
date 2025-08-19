import 'package:client/client.dart';
import 'package:domain/domain.dart';
import 'package:ignitor/src/common/client/dto/api_quote.dart';
import 'package:ignitor/src/features/quotes/data/mapper/quotes_mapper.dart';

abstract interface class QuotesRemoteDataSource {
  /// Fetches a list of quotes from the remote source.
  Future<List<QuoteEntity>> fetchQuotes();
}

class QuotesRemoteDataSourceImpl implements QuotesRemoteDataSource {
  QuotesRemoteDataSourceImpl({required this.client});
  final Client client;

  @override
  Future<List<QuoteEntity>> fetchQuotes() async {
    final response = await client.get('/quotes');
    return (response!['quotes'] as List)
        .map(
          (json) => QuotesMapper$Api$Entity().map1(
            ApiQuote.fromJson(json as Map<String, dynamic>),
          ),
        )
        .toList();
  }
}

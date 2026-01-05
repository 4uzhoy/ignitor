import 'package:client/client.dart';
import 'package:domain/domain.dart';
import 'package:ignitor/src/common/client/dto/api_quote.dart';
import 'package:ignitor/src/common/client/rest_client_api.dart';
import 'package:ignitor/src/features/quotes/data/mapper/quotes_mapper.dart';

abstract interface class QuotesRemoteDataSource {
  /// Fetches a list of quotes from the remote source.
  Future<Entities<QuoteEntity>> fetchQuotes();
}

class QuotesRemoteDataSourceImpl implements QuotesRemoteDataSource {
  QuotesRemoteDataSourceImpl({required this.api$quotes});
  final ClientApi$Quotes api$quotes;

  @override
  Future<Entities<QuoteEntity>> fetchQuotes() async {
    final response = await api$quotes.fetchQuotes();
    if (response?['quotes'] == null || (response!['quotes'] is! JsonList))
      return Entities<QuoteEntity>.empty();
    final list =
        (response!['quotes'] as JsonList)
            .map<QuoteEntity>(
              (json) => QuotesMapper$Api$Entity().map1(ApiQuote.fromJson(json)),
            )
            .toList();
    return Entities.fromList(list);
  }
}

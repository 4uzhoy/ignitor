import 'package:client/client.dart';
import 'package:ignitor/src/common/client/dto/api_quote.dart';

abstract base class RestClientApi {
  const RestClientApi({required this.client});
  final Client client;
}

final class RestClientApi$Quotes extends RestClientApi {
  const RestClientApi$Quotes({required super.client});

  /// Fetches a list of quotes.
  Future<List<ApiQuote>> fetchQuotes() async {
    final response = await client.get('/quotes');
    return (response!['quotes'] as List)
        .map((json) => ApiQuote.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

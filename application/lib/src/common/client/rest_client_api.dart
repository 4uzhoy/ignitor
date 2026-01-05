import 'package:client/client.dart';

final class ClientApi$Quotes extends ClientApi {
  const ClientApi$Quotes({required super.client});

  /// Fetches a list of quotes.
  Future<JsonMap?> fetchQuotes() async {
    final response = await client.get(node);
    return response;
  }

  @override
  String get node => 'quotes';
}

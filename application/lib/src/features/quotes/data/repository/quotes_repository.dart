import 'package:domain/domain.dart';
import 'package:ignitor/src/features/quotes/data/source/quotes_remote_data_source.dart';

final class QuotesRepositoryImpl implements QuotesRepository {
  const QuotesRepositoryImpl({
    required QuotesRemoteDataSource quotesRemoteDataSource,
  }) : _quotesRemoteDataSource = quotesRemoteDataSource;

  final QuotesRemoteDataSource _quotesRemoteDataSource;
  @override
  Future<List<QuoteEntity>> fetchQuotes() =>
      _quotesRemoteDataSource.fetchQuotes();
}

import 'package:control/control.dart';
import 'package:domain/domain.dart';
import 'package:meta/meta.dart';

sealed class QuotesState extends _$BaseQuotesState {
  const QuotesState({required super.quotes});
}

final class QuotesState$Idle extends QuotesState {
  const QuotesState$Idle({required super.quotes});

  factory QuotesState$Idle.initial() =>
      QuotesState$Idle(quotes: Entities<QuoteEntity>.empty());
}

final class QuotesState$Processed extends QuotesState {
  const QuotesState$Processed({required super.quotes});
}

final class QuotesState$Error extends QuotesState {
  const QuotesState$Error({required super.quotes, required this.error});

  final Object error;
}

final class QuotesState$Successful extends QuotesState {
  const QuotesState$Successful({required super.quotes});
}

base class _$BaseQuotesState {
  const _$BaseQuotesState({required this.quotes});

  @nonVirtual
  final Entities<QuoteEntity> quotes;
}

final class QuotesController extends StateController<QuotesState>
    with SequentialControllerHandler {
  QuotesController({required QuotesRepository quotesRepository})
    : _quotesRepository = quotesRepository,
      super(initialState: QuotesState$Idle.initial());

  final QuotesRepository _quotesRepository;

  void fetchQuotes() => handle(
    name: 'fetchQuotes',
    meta: {'state': state.runtimeType},
    () async {
      setState(QuotesState$Processed(quotes: state.quotes));

      /// a small delay to simulate long network request
      await Future<void>.delayed(const Duration(milliseconds: 3000));
      final quotes = await _quotesRepository.fetchQuotes();
      setState(QuotesState$Successful(quotes: Entities.fromList(quotes)));
    },
    error: (error, stackTrace) async {
      setState(QuotesState$Error(quotes: state.quotes, error: error));
    },
    done: () async {},
  );
}

import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:ignitor/src/common/client/dto/api_quote.dart';

class QuotesMapper$Api$Entity extends BaseMapper<QuoteEntity> with BaseMapperMixin1<QuoteEntity, ApiQuote> {
  @override
  QuoteEntity map1(ApiQuote a) => QuoteEntity(id: a.id.toString(), text: a.quote, author: a.author);
}

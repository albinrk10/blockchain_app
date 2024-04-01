import 'package:example2/app/domain/either/either.dart';
import 'package:example2/app/domain/failures/http_request_failure.dart';
import 'package:example2/app/domain/models/crypto/crypto.dart';

typedef GetPricesFuture = Future<Either<HttpRequestFailure, List<Crypto>>>;

abstract class ExchangeRepository {
  GetPricesFuture getPrices(List<String> ids);
}

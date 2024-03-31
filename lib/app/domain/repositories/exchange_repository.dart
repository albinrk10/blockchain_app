import '../results/get_prices/get_prices_result.dart';

abstract class ExchangeRepository {
  Future<GetPricesResult> getPrices(List<String> ids);
}

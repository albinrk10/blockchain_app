import 'package:example2/app/data/services/remote/exchage_api.dart';
import 'package:example2/app/domain/repositories/exchange_repository.dart';

class ExchangeRepositoryImpl implements ExchangeRepository {
  final ExchangeAPI _api;

  ExchangeRepositoryImpl(this._api);
  
  @override
  GetPricesFuture getPrices(List<String> ids) {
   return _api.getPrices(ids);
  }

 
}

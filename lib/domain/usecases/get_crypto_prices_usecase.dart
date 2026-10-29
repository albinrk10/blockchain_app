import 'package:fpdart/fpdart.dart';
import '../../core/failures/failure.dart';
import '../entities/crypto.dart';
import '../repositories/crypto_repository.dart';

class GetCryptoPricesUseCase {
  final CryptoRepository _repository;

  const GetCryptoPricesUseCase(this._repository);

  Future<Either<Failure, List<Crypto>>> call(List<String> ids) {
    return _repository.getCryptoPrices(ids);
  }
}

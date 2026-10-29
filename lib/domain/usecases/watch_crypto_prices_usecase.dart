import 'package:fpdart/fpdart.dart';
import '../../core/failures/failure.dart';
import '../repositories/crypto_ws_repository.dart';

class WatchCryptoPricesUseCase {
  final CryptoWsRepository _repository;

  const WatchCryptoPricesUseCase(this._repository);

  Future<Either<Failure, void>> start(List<String> ids) {
    return _repository.connect(ids);
  }

  Stream<Map<String, double>> get pricesStream => _repository.onPricesChanged;

  Future<void> stop() => _repository.disconnect();
}

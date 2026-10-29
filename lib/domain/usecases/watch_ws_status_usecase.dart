import '../entities/ws_status.dart';
import '../repositories/crypto_ws_repository.dart';

class WatchWsStatusUseCase {
  final CryptoWsRepository _repository;

  const WatchWsStatusUseCase(this._repository);

  Stream<WsStatus> get statusStream => _repository.onStatusChanged;
}

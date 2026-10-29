import 'package:fpdart/fpdart.dart';
import '../../core/failures/failure.dart';
import '../../domain/entities/ws_status.dart';
import '../../domain/repositories/crypto_ws_repository.dart';
import '../datasources/websocket/crypto_ws_data_source.dart';

class CryptoWsRepositoryImpl implements CryptoWsRepository {
  final CryptoWsDataSource _dataSource;

  CryptoWsRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, void>> connect(List<String> ids) {
    return _dataSource.connect(ids);
  }

  @override
  Stream<Map<String, double>> get onPricesChanged => _dataSource.priceUpdates;

  @override
  Stream<WsStatus> get onStatusChanged => _dataSource.statusUpdates;

  @override
  Future<void> disconnect() => _dataSource.disconnect();
}

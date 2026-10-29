import 'package:fpdart/fpdart.dart';
import '../../core/failures/failure.dart';
import '../entities/ws_status.dart';

abstract interface class CryptoWsRepository {
  Future<Either<Failure, void>> connect(List<String> ids);
  Stream<Map<String, double>> get onPricesChanged;
  Stream<WsStatus> get onStatusChanged;
  Future<void> disconnect();
}

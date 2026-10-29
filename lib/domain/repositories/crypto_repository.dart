import 'package:fpdart/fpdart.dart';
import '../../core/failures/failure.dart';
import '../entities/crypto.dart';

abstract interface class CryptoRepository {
  Future<Either<Failure, List<Crypto>>> getCryptoPrices(List<String> ids);
}

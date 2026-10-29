import 'package:fpdart/fpdart.dart';
import '../../core/failures/failure.dart';
import '../../domain/entities/crypto.dart';
import '../../domain/repositories/crypto_repository.dart';
import '../datasources/remote/crypto_rest_data_source.dart';

class CryptoRepositoryImpl implements CryptoRepository {
  final CryptoRestDataSource _dataSource;

  CryptoRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<Crypto>>> getCryptoPrices(List<String> ids) async {
    final result = await _dataSource.fetchAssets(ids);
    
    return result.map(
      (dtos) => dtos.map((dto) => dto.toDomain()).toList(),
    );
  }
}

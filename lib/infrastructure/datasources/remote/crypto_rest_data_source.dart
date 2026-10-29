import 'dart:convert';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_constants.dart';
import '../../../core/failures/failure.dart';
import '../../models/crypto_dto.dart';

abstract interface class CryptoRestDataSource {
  Future<Either<Failure, List<CryptoDto>>> fetchAssets([List<String>? ids]);
}

class CryptoRestDataSourceImpl implements CryptoRestDataSource {
  final http.Client _client;

  CryptoRestDataSourceImpl(this._client);

  @override
  Future<Either<Failure, List<CryptoDto>>> fetchAssets([List<String>? ids]) async {
    try {
      final targetPairs = (ids == null || ids.isEmpty)
          ? AppConstants.defaultCryptoPairs
          : ids;

      // Binance ticker endpoint accepts formatted symbols array: ["BTCUSDT","ETHUSDT",...]
      final uri = Uri.parse(
        '${AppConstants.restBaseUrl}?symbols=${jsonEncode(targetPairs)}',
      );

      final response = await _client.get(uri).timeout(AppConstants.restTimeout);

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        final List<dynamic> list = decoded is List ? decoded : [decoded];

        final dtos = list
            .map((item) => CryptoDto.fromJson(item as Map<String, dynamic>))
            .toList();

        return Right(dtos);
      }

      if (response.statusCode == 404) {
        return const Left(NotFoundFailure());
      }

      if (response.statusCode >= 500) {
        return Left(ServerFailure(
          statusCode: response.statusCode,
          message: 'Error en el servidor de criptomonedas (${response.statusCode})',
        ));
      }

      return Left(ServerFailure(
        statusCode: response.statusCode,
        message: 'Respuesta inesperada del servidor: ${response.statusCode}',
      ));
    } on SocketException {
      return const Left(NetworkFailure());
    } on http.ClientException {
      return const Left(NetworkFailure());
    } on FormatException catch (e) {
      return Left(ParsingFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e));
    }
  }
}

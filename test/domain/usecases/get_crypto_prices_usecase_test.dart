import 'package:blockchain_app/core/failures/failure.dart';
import 'package:blockchain_app/domain/entities/crypto.dart';
import 'package:blockchain_app/domain/repositories/crypto_repository.dart';
import 'package:blockchain_app/domain/usecases/get_crypto_prices_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockCryptoRepository extends Mock implements CryptoRepository {}

void main() {
  late MockCryptoRepository mockRepo;
  late GetCryptoPricesUseCase useCase;

  setUp(() {
    mockRepo = MockCryptoRepository();
    useCase = GetCryptoPricesUseCase(mockRepo);
  });

  const testCryptos = [
    Crypto(
      id: 'bitcoin',
      symbol: 'BTC',
      name: 'Bitcoin',
      price: 68000.0,
      changePercent24Hr: 3.2,
    ),
  ];

  group('GetCryptoPricesUseCase', () {
    test('delegates call to repository and returns Right on success', () async {
      when(() => mockRepo.getCryptoPrices(any()))
          .thenAnswer((_) async => const Right(testCryptos));

      final result = await useCase(['bitcoin']);

      expect(result, const Right(testCryptos));
      verify(() => mockRepo.getCryptoPrices(['bitcoin'])).called(1);
    });

    test('returns Left with Failure when repository fails', () async {
      const failure = NetworkFailure('Error de red');
      when(() => mockRepo.getCryptoPrices(any()))
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase(['bitcoin']);

      expect(result, const Left(failure));
      verify(() => mockRepo.getCryptoPrices(['bitcoin'])).called(1);
    });
  });
}

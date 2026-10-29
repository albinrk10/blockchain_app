import 'dart:io';
import 'package:blockchain_app/core/failures/failure.dart';
import 'package:blockchain_app/infrastructure/datasources/remote/crypto_rest_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockClient;
  late CryptoRestDataSourceImpl dataSource;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockClient = MockHttpClient();
    dataSource = CryptoRestDataSourceImpl(mockClient);
  });

  group('CryptoRestDataSource', () {
    test('returns Right with dtos when response code is 200', () async {
      const responseBody = '''
      [
        {
          "symbol": "BTCUSDT",
          "lastPrice": "65000.00",
          "priceChangePercent": "1.50"
        }
      ]
      ''';

      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response(responseBody, 200),
      );

      final result = await dataSource.fetchAssets(['BTCUSDT']);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should not be a failure'),
        (dtos) {
          expect(dtos.length, 1);
          expect(dtos.first.id, 'BTCUSDT');
          expect(dtos.first.symbol, 'BTC');
          expect(dtos.first.name, 'Bitcoin');
          expect(dtos.first.priceUsd, 65000.0);
        },
      );
    });

    test('returns Left(NotFoundFailure) when status code is 404', () async {
      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response('Not found', 404),
      );

      final result = await dataSource.fetchAssets(['UNKNOWN']);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Should fail'),
      );
    });

    test('returns Left(ServerFailure) when status code is 500', () async {
      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response('Server error', 500),
      );

      final result = await dataSource.fetchAssets(['BTCUSDT']);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect((failure as ServerFailure).statusCode, 500);
        },
        (_) => fail('Should fail'),
      );
    });

    test('returns Left(NetworkFailure) on SocketException', () async {
      when(() => mockClient.get(any())).thenThrow(
        const SocketException('Failed to connect to host'),
      );

      final result = await dataSource.fetchAssets(['BTCUSDT']);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Should fail'),
      );
    });
  });
}

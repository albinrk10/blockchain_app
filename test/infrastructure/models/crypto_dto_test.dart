import 'package:blockchain_app/infrastructure/models/crypto_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CryptoDto', () {
    test('fromJson parses Binance ticker JSON properly', () {
      final json = {
        'symbol': 'BTCUSDT',
        'lastPrice': '67450.25',
        'priceChangePercent': '2.45',
      };

      final dto = CryptoDto.fromJson(json);

      expect(dto.id, 'BTCUSDT');
      expect(dto.symbol, 'BTC');
      expect(dto.name, 'Bitcoin');
      expect(dto.priceUsd, 67450.25);
      expect(dto.changePercent24Hr, 2.45);
    });

    test('fromJson handles null or invalid values safely', () {
      final json = <String, dynamic>{
        'symbol': null,
        'lastPrice': 'invalid_number',
        'priceChangePercent': null,
      };

      final dto = CryptoDto.fromJson(json);

      expect(dto.id, '');
      expect(dto.symbol, '');
      expect(dto.name, '');
      expect(dto.priceUsd, 0.0);
      expect(dto.changePercent24Hr, 0.0);
    });

    test('toDomain maps cleanly to domain entity', () {
      const dto = CryptoDto(
        id: 'ETHUSDT',
        symbol: 'ETH',
        name: 'Ethereum',
        priceUsd: 3500.50,
        changePercent24Hr: -1.25,
      );

      final domain = dto.toDomain();

      expect(domain.id, 'ETHUSDT');
      expect(domain.symbol, 'ETH');
      expect(domain.name, 'Ethereum');
      expect(domain.price, 3500.50);
      expect(domain.changePercent24Hr, -1.25);
      expect(domain.lastUpdated, isNotNull);
    });
  });
}

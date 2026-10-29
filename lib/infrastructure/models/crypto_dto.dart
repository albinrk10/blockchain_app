import '../../core/constants/app_constants.dart';
import '../../domain/entities/crypto.dart';

class CryptoDto {
  final String id;
  final String symbol;
  final String name;
  final double priceUsd;
  final double changePercent24Hr;

  const CryptoDto({
    required this.id,
    required this.symbol,
    required this.name,
    required this.priceUsd,
    required this.changePercent24Hr,
  });

  factory CryptoDto.fromJson(Map<String, dynamic> json) {
    // Supports Binance format (symbol, lastPrice, priceChangePercent)
    // and legacy format (id, symbol, name, priceUsd, changePercent24Hr)
    final pair = json['symbol'] as String? ?? json['id'] as String? ?? '';
    final meta = AppConstants.assetMetadata[pair];

    final symbol = meta?.symbol ??
        (pair.endsWith('USDT')
            ? pair.replaceAll('USDT', '')
            : (json['symbol'] as String? ?? pair)).toUpperCase();

    final name = meta?.name ?? (json['name'] as String? ?? symbol);

    final rawPrice = json['lastPrice'] ?? json['priceUsd'] ?? json['price'] ?? '0';
    final rawChange = json['priceChangePercent'] ?? json['changePercent24Hr'] ?? '0';

    return CryptoDto(
      id: pair,
      symbol: symbol,
      name: name,
      priceUsd: double.tryParse(rawPrice.toString()) ?? 0.0,
      changePercent24Hr: double.tryParse(rawChange.toString()) ?? 0.0,
    );
  }

  Crypto toDomain() {
    return Crypto(
      id: id,
      symbol: symbol,
      name: name,
      price: priceUsd,
      changePercent24Hr: changePercent24Hr,
      lastUpdated: DateTime.now(),
    );
  }
}

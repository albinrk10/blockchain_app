abstract final class AppConstants {
  static const String appTitle = 'Crypto Pulse';

  // Binance Public API (100% free, no API key required, reliable 24/7)
  static const String restBaseUrl = 'https://api.binance.com/api/v3/ticker/24hr';
  static const String wsBaseUrl = 'wss://stream.binance.com:9443/stream';

  static const List<String> defaultCryptoPairs = [
    'BTCUSDT',
    'ETHUSDT',
    'BNBUSDT',
    'DOGEUSDT',
    'LTCUSDT',
    'USDCUSDT',
  ];

  static const Map<String, ({String name, String symbol})> assetMetadata = {
    'BTCUSDT': (name: 'Bitcoin', symbol: 'BTC'),
    'ETHUSDT': (name: 'Ethereum', symbol: 'ETH'),
    'BNBUSDT': (name: 'BNB', symbol: 'BNB'),
    'DOGEUSDT': (name: 'Dogecoin', symbol: 'DOGE'),
    'LTCUSDT': (name: 'Litecoin', symbol: 'LTC'),
    'USDCUSDT': (name: 'USD Coin', symbol: 'USDC'),
  };

  static const Duration wsReconnectDelay = Duration(seconds: 4);
  static const Duration restTimeout = Duration(seconds: 10);
  static const Duration priceHighlightDuration = Duration(milliseconds: 1200);
}

import 'dart:async';
import 'package:blockchain_app/core/failures/failure.dart';
import 'package:blockchain_app/domain/entities/crypto.dart';
import 'package:blockchain_app/domain/entities/ws_status.dart';
import 'package:blockchain_app/domain/usecases/get_crypto_prices_usecase.dart';
import 'package:blockchain_app/domain/usecases/watch_crypto_prices_usecase.dart';
import 'package:blockchain_app/domain/usecases/watch_ws_status_usecase.dart';
import 'package:blockchain_app/presentation/controllers/home_notifier.dart';
import 'package:blockchain_app/presentation/controllers/home_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCryptoPricesUseCase extends Mock implements GetCryptoPricesUseCase {}
class MockWatchCryptoPricesUseCase extends Mock implements WatchCryptoPricesUseCase {}
class MockWatchWsStatusUseCase extends Mock implements WatchWsStatusUseCase {}

void main() {
  late MockGetCryptoPricesUseCase mockGetPrices;
  late MockWatchCryptoPricesUseCase mockWatchPrices;
  late MockWatchWsStatusUseCase mockWatchStatus;
  late StreamController<Map<String, double>> pricesController;
  late StreamController<WsStatus> statusController;
  late HomeNotifier notifier;

  const testCryptos = [
    Crypto(
      id: 'bitcoin',
      symbol: 'BTC',
      name: 'Bitcoin',
      price: 60000.0,
      changePercent24Hr: 2.5,
    ),
    Crypto(
      id: 'ethereum',
      symbol: 'ETH',
      name: 'Ethereum',
      price: 3000.0,
      changePercent24Hr: -1.0,
    ),
  ];

  setUp(() {
    mockGetPrices = MockGetCryptoPricesUseCase();
    mockWatchPrices = MockWatchCryptoPricesUseCase();
    mockWatchStatus = MockWatchWsStatusUseCase();
    pricesController = StreamController<Map<String, double>>.broadcast();
    statusController = StreamController<WsStatus>.broadcast();

    when(() => mockWatchPrices.start(any())).thenAnswer((_) async => const Right(null));
    when(() => mockWatchPrices.stop()).thenAnswer((_) async {});
    when(() => mockWatchPrices.pricesStream).thenAnswer((_) => pricesController.stream);
    when(() => mockWatchStatus.statusStream).thenAnswer((_) => statusController.stream);

    notifier = HomeNotifier(
      getCryptoPricesUseCase: mockGetPrices,
      watchCryptoPricesUseCase: mockWatchPrices,
      watchWsStatusUseCase: mockWatchStatus,
      cryptoIds: ['bitcoin', 'ethereum'],
    );
  });

  tearDown(() {
    pricesController.close();
    statusController.close();
    notifier.dispose();
  });

  group('HomeNotifier', () {
    test('initial state is HomeInitial', () {
      expect(notifier.state, isA<HomeInitial>());
    });

    test('init emits loaded state when fetch succeeds', () async {
      when(() => mockGetPrices(any())).thenAnswer((_) async => const Right(testCryptos));

      await notifier.init();

      expect(notifier.state, isA<HomeLoaded>());
      final loaded = notifier.state as HomeLoaded;
      expect(loaded.cryptos.length, 2);
      expect(loaded.cryptos.first.name, 'Bitcoin');
    });

    test('init emits failure state when fetch fails', () async {
      const failure = ServerFailure(statusCode: 500);
      when(() => mockGetPrices(any())).thenAnswer((_) async => const Left(failure));

      await notifier.init();

      expect(notifier.state, isA<HomeFailure>());
      final failed = notifier.state as HomeFailure;
      expect(failed.failure, failure);
    });

    test('updates price and trend when WebSocket message arrives', () async {
      when(() => mockGetPrices(any())).thenAnswer((_) async => const Right(testCryptos));
      await notifier.init();

      // Emit new price for Bitcoin (higher)
      pricesController.add({'bitcoin': 62000.0});
      await Future<void>.delayed(Duration.zero);

      final loaded = notifier.state as HomeLoaded;
      final btc = loaded.cryptos.firstWhere((c) => c.id == 'bitcoin');
      expect(btc.price, 62000.0);
      expect(loaded.priceTrends['bitcoin'], PriceTrend.up);
    });

    test('search filters cryptos correctly', () async {
      when(() => mockGetPrices(any())).thenAnswer((_) async => const Right(testCryptos));
      await notifier.init();

      notifier.onSearchChanged('eth');
      final loaded = notifier.state as HomeLoaded;
      expect(loaded.filteredCryptos.length, 1);
      expect(loaded.filteredCryptos.first.symbol, 'ETH');
    });

    test('updates wsStatus on WebSocket status change', () async {
      when(() => mockGetPrices(any())).thenAnswer((_) async => const Right(testCryptos));
      await notifier.init();

      statusController.add(const WsStatus.connected());
      await Future<void>.delayed(Duration.zero);

      final loaded = notifier.state as HomeLoaded;
      expect(loaded.wsStatus, isA<WsStatusConnected>());
    });
  });
}

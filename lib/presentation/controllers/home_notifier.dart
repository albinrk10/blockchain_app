import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/crypto.dart';
import '../../domain/entities/ws_status.dart';
import '../../domain/usecases/get_crypto_prices_usecase.dart';
import '../../domain/usecases/watch_crypto_prices_usecase.dart';
import '../../domain/usecases/watch_ws_status_usecase.dart';
import 'home_state.dart';

class HomeNotifier extends ChangeNotifier {
  final GetCryptoPricesUseCase _getCryptoPricesUseCase;
  final WatchCryptoPricesUseCase _watchCryptoPricesUseCase;
  final WatchWsStatusUseCase _watchWsStatusUseCase;
  final List<String> _ids;

  HomeNotifier({
    required GetCryptoPricesUseCase getCryptoPricesUseCase,
    required WatchCryptoPricesUseCase watchCryptoPricesUseCase,
    required WatchWsStatusUseCase watchWsStatusUseCase,
    List<String>? cryptoIds,
  })  : _getCryptoPricesUseCase = getCryptoPricesUseCase,
        _watchCryptoPricesUseCase = watchCryptoPricesUseCase,
        _watchWsStatusUseCase = watchWsStatusUseCase,
        _ids = cryptoIds ?? AppConstants.defaultCryptoPairs;

  HomeState _state = const HomeState.initial();
  HomeState get state => _state;

  StreamSubscription<Map<String, double>>? _pricesSubscription;
  StreamSubscription<WsStatus>? _statusSubscription;
  final Map<String, Timer> _trendTimers = {};

  Future<void> init() async {
    _state = const HomeState.loading();
    notifyListeners();

    final result = await _getCryptoPricesUseCase(_ids);

    result.fold(
      (failure) {
        _state = HomeState.failure(failure);
        notifyListeners();
      },
      (cryptos) {
        _state = HomeState.loaded(
          cryptos: cryptos,
          wsStatus: const WsStatus.connecting(),
        );
        notifyListeners();
        _startListening();
      },
    );
  }

  Future<void> refresh() async {
    final result = await _getCryptoPricesUseCase(_ids);

    result.fold(
      (failure) {
        // If already loaded, we don't necessarily clear current list, but if initial failure we update
        if (_state is! HomeLoaded) {
          _state = HomeState.failure(failure);
          notifyListeners();
        }
      },
      (cryptos) {
        if (_state case final HomeLoaded loaded) {
          _state = loaded.copyWith(cryptos: cryptos);
        } else {
          _state = HomeState.loaded(cryptos: cryptos);
          _startListening();
        }
        notifyListeners();
      },
    );
  }

  void _startListening() {
    _pricesSubscription?.cancel();
    _statusSubscription?.cancel();

    _watchCryptoPricesUseCase.start(_ids);

    _pricesSubscription = _watchCryptoPricesUseCase.pricesStream.listen(
      _onPriceUpdates,
    );

    _statusSubscription = _watchWsStatusUseCase.statusStream.listen(
      _onStatusUpdate,
    );
  }

  void _onPriceUpdates(Map<String, double> updates) {
    if (_state case final HomeLoaded loaded) {
      final updatedCryptos = <Crypto>[];
      final newTrends = Map<String, PriceTrend>.from(loaded.priceTrends);

      for (final crypto in loaded.cryptos) {
        final newPrice = updates[crypto.id];
        if (newPrice != null && newPrice != crypto.price) {
          final trend = newPrice > crypto.price
              ? PriceTrend.up
              : PriceTrend.down;

          newTrends[crypto.id] = trend;

          _trendTimers[crypto.id]?.cancel();
          _trendTimers[crypto.id] = Timer(
            AppConstants.priceHighlightDuration,
            () => _resetTrend(crypto.id),
          );

          updatedCryptos.add(
            crypto.copyWith(
              price: newPrice,
              lastUpdated: DateTime.now(),
            ),
          );
        } else {
          updatedCryptos.add(crypto);
        }
      }

      _state = loaded.copyWith(
        cryptos: updatedCryptos,
        priceTrends: newTrends,
      );
      notifyListeners();
    }
  }

  void _resetTrend(String id) {
    if (_state case final HomeLoaded loaded) {
      if (loaded.priceTrends.containsKey(id)) {
        final updatedTrends = Map<String, PriceTrend>.from(loaded.priceTrends)
          ..remove(id);
        _state = loaded.copyWith(priceTrends: updatedTrends);
        notifyListeners();
      }
    }
  }

  void _onStatusUpdate(WsStatus status) {
    if (_state case final HomeLoaded loaded) {
      _state = loaded.copyWith(wsStatus: status);
      notifyListeners();
    }
  }

  void onSearchChanged(String query) {
    if (_state case final HomeLoaded loaded) {
      _state = loaded.copyWith(searchQuery: query);
      notifyListeners();
    }
  }

  Future<void> retryWebSocket() async {
    if (_state case final HomeLoaded loaded) {
      _state = loaded.copyWith(wsStatus: const WsStatus.connecting());
      notifyListeners();
      await _watchCryptoPricesUseCase.start(_ids);
    }
  }

  @override
  void dispose() {
    for (final timer in _trendTimers.values) {
      timer.cancel();
    }
    _trendTimers.clear();
    _pricesSubscription?.cancel();
    _statusSubscription?.cancel();
    _watchCryptoPricesUseCase.stop();
    super.dispose();
  }
}

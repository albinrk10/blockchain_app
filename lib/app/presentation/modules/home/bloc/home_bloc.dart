import 'dart:async';
import 'package:example2/app/domain/models/ws_status/ws_status.dart';
import 'package:example2/app/domain/repositories/exchange_repository.dart';
import 'package:example2/app/domain/repositories/ws_repository.dart';
import 'package:example2/app/presentation/modules/home/bloc/home_state.dart';
import 'package:flutter/widgets.dart';

class HomeBloc extends ChangeNotifier {
  HomeBloc({
    required this.exchangeRepository,
    required this.wsRepository,
  });

  final ExchangeRepository exchangeRepository;
  final WsRepository wsRepository;
  StreamSubscription? _pricesSubcription , _wsSubcription;

  HomeState _state = const HomeState.loading();

  HomeState get state => _state;

  final _ids = [
    'bitcoin',
    'ethereum',
    'tether',
    'binance-coin',
    'monero',
    'litecoin',
    'usd-coin',
    'dogecoin',
  ];

  Future<void> init() async {
    state.maybeWhen(
      loading: () {},
      orElse: () => {
        _state = const HomeState.loading(),
        notifyListeners(),
      },
    );
    final result = await exchangeRepository.getPrices(_ids);

    _state = result.when(
      left: (failure) => HomeState.failed(failure),
      right: (cryptos) {
        starPriceListening();
        return HomeState.loaded(
          cryptos: cryptos,
        );
      },
    );

    notifyListeners();
  }

  Future<bool> starPriceListening() async {
    final connected = await wsRepository.connect(
      _ids,
    );
    state.mapOrNull(
      loaded: (state) {
        if (connected) {
          _onPricesChanged();
        }
        _state = state.copyWith(
          wsStatus:
              connected ? const WsStatus.connected() : const WsStatus.failed(),
        );
        notifyListeners();
      },
    );

    return connected;
  }

  void _onPricesChanged() {
    _pricesSubcription?.cancel();
    _wsSubcription?.cancel();
    _pricesSubcription = wsRepository.onPricesChanged.listen(
      (changes) {
        state.mapOrNull(
          loaded: (state) {
            final key = changes.keys;
            _state = state.copyWith(
              cryptos: [
                ...state.cryptos.map(
                  (crypto) {
                    if (key.contains(crypto.id)) {
                      return crypto.copyWith(
                        price: changes[crypto.id]!,
                      );
                    }
                    return crypto;
                  },
                )
              ],
            );
            notifyListeners();
          },
        );
      },
    );
   _wsSubcription = wsRepository.onStatusChanged.listen((status) {
    state.mapOrNull(
      loaded: (state) {
        _state = state.copyWith(
          wsStatus: status,
        );
        notifyListeners();
      },
    );
   });
  }

  @override
  void dispose() {
    _pricesSubcription?.cancel();
    _wsSubcription?.cancel();
    super.dispose();
  }
}

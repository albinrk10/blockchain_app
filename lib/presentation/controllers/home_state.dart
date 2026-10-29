import 'package:flutter/foundation.dart';
import '../../core/failures/failure.dart';
import '../../domain/entities/crypto.dart';
import '../../domain/entities/ws_status.dart';

enum PriceTrend { up, down, neutral }

@immutable
sealed class HomeState {
  const HomeState();

  const factory HomeState.initial() = HomeInitial;
  const factory HomeState.loading() = HomeLoading;
  const factory HomeState.loaded({
    required List<Crypto> cryptos,
    WsStatus wsStatus,
    String searchQuery,
    Map<String, PriceTrend> priceTrends,
  }) = HomeLoaded;
  const factory HomeState.failure(Failure failure) = HomeFailure;

  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(HomeLoaded state) loaded,
    required T Function(Failure error) failure,
  }) {
    return switch (this) {
      HomeInitial() => initial(),
      HomeLoading() => loading(),
      final HomeLoaded loadedState => loaded(loadedState),
      HomeFailure(failure: final err) => failure(err),
    };
  }
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  final List<Crypto> cryptos;
  final WsStatus wsStatus;
  final String searchQuery;
  final Map<String, PriceTrend> priceTrends;

  const HomeLoaded({
    required this.cryptos,
    this.wsStatus = const WsStatus.connecting(),
    this.searchQuery = '',
    this.priceTrends = const {},
  });

  List<Crypto> get filteredCryptos {
    if (searchQuery.trim().isEmpty) {
      return cryptos;
    }
    final q = searchQuery.toLowerCase().trim();
    return cryptos.where((c) {
      return c.name.toLowerCase().contains(q) ||
          c.symbol.toLowerCase().contains(q);
    }).toList();
  }

  HomeLoaded copyWith({
    List<Crypto>? cryptos,
    WsStatus? wsStatus,
    String? searchQuery,
    Map<String, PriceTrend>? priceTrends,
  }) {
    return HomeLoaded(
      cryptos: cryptos ?? this.cryptos,
      wsStatus: wsStatus ?? this.wsStatus,
      searchQuery: searchQuery ?? this.searchQuery,
      priceTrends: priceTrends ?? this.priceTrends,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeLoaded &&
        listEquals(other.cryptos, cryptos) &&
        other.wsStatus == wsStatus &&
        other.searchQuery == searchQuery &&
        mapEquals(other.priceTrends, priceTrends);
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(cryptos),
        wsStatus,
        searchQuery,
        Object.hashAll(priceTrends.entries),
      );
}

final class HomeFailure extends HomeState {
  final Failure failure;
  const HomeFailure(this.failure);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeFailure && other.failure == failure;
  }

  @override
  int get hashCode => failure.hashCode;
}

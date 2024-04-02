import 'package:example2/app/domain/failures/http_request_failure.dart';
import 'package:example2/app/domain/models/crypto/crypto.dart';
import 'package:example2/app/domain/models/ws_status/ws_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.loading() = _Loading;
  const factory HomeState.failed(HttpRequestFailure failure) = _Failed;
  const factory HomeState.loaded(
   {required List<Crypto> cryptos,
   @Default(WsStatus.connecting()) WsStatus wsStatus ,}
    ) = _Loaded;
}


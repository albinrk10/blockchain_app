import 'package:flutter/foundation.dart';

@immutable
sealed class WsStatus {
  const WsStatus();

  const factory WsStatus.connecting() = WsStatusConnecting;
  const factory WsStatus.connected() = WsStatusConnected;
  const factory WsStatus.disconnected() = WsStatusDisconnected;
  const factory WsStatus.failed([String? reason]) = WsStatusFailed;

  T when<T>({
    required T Function() connecting,
    required T Function() connected,
    required T Function() disconnected,
    required T Function(String? reason) failed,
  }) {
    return switch (this) {
      WsStatusConnecting() => connecting(),
      WsStatusConnected() => connected(),
      WsStatusDisconnected() => disconnected(),
      WsStatusFailed(:final reason) => failed(reason),
    };
  }
}

final class WsStatusConnecting extends WsStatus {
  const WsStatusConnecting();

  @override
  String toString() => 'WsStatus.connecting';
}

final class WsStatusConnected extends WsStatus {
  const WsStatusConnected();

  @override
  String toString() => 'WsStatus.connected';
}

final class WsStatusDisconnected extends WsStatus {
  const WsStatusDisconnected();

  @override
  String toString() => 'WsStatus.disconnected';
}

final class WsStatusFailed extends WsStatus {
  final String? reason;
  const WsStatusFailed([this.reason]);

  @override
  String toString() => 'WsStatus.failed(reason: $reason)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WsStatusFailed && other.reason == reason;
  }

  @override
  int get hashCode => reason.hashCode;
}

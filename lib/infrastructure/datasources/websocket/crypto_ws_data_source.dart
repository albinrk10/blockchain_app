import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/failures/failure.dart';
import '../../../domain/entities/ws_status.dart';

typedef WebSocketChannelFactory = WebSocketChannel Function(Uri uri);

abstract interface class CryptoWsDataSource {
  Future<Either<Failure, void>> connect(List<String> ids);
  Stream<Map<String, double>> get priceUpdates;
  Stream<WsStatus> get statusUpdates;
  Future<void> disconnect();
}

class CryptoWsDataSourceImpl implements CryptoWsDataSource {
  final WebSocketChannelFactory _channelFactory;
  final Duration _reconnectDelay;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  Timer? _reconnectTimer;
  List<String> _currentIds = [];
  bool _isManuallyClosed = false;

  final StreamController<Map<String, double>> _pricesController =
      StreamController<Map<String, double>>.broadcast();

  final StreamController<WsStatus> _statusController =
      StreamController<WsStatus>.broadcast();

  CryptoWsDataSourceImpl({
    WebSocketChannelFactory? channelFactory,
    Duration? reconnectDelay,
  })  : _channelFactory = channelFactory ?? WebSocketChannel.connect,
        _reconnectDelay = reconnectDelay ?? AppConstants.wsReconnectDelay;

  @override
  Stream<Map<String, double>> get priceUpdates => _pricesController.stream;

  @override
  Stream<WsStatus> get statusUpdates => _statusController.stream;

  @override
  Future<Either<Failure, void>> connect(List<String> ids) async {
    _currentIds = ids.isNotEmpty ? ids : AppConstants.defaultCryptoPairs;
    _isManuallyClosed = false;
    _reconnectTimer?.cancel();

    _emitStatus(const WsStatus.connecting());

    try {
      final streams = _currentIds
          .map((pair) => '${pair.toLowerCase()}@ticker')
          .join('/');

      final uri = Uri.parse('${AppConstants.wsBaseUrl}?streams=$streams');
      _channel = _channelFactory(uri);

      await _channel!.ready;

      _subscription?.cancel();
      _subscription = _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );

      _emitStatus(const WsStatus.connected());
      return const Right(null);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[CryptoWsDataSource] Connection failed: $e');
      }
      _emitStatus(WsStatus.failed(e.toString()));
      _scheduleReconnect();
      return Left(WebSocketFailure(e.toString()));
    }
  }

  void _onMessage(dynamic message) {
    try {
      final dynamic decoded = jsonDecode(message.toString());
      if (decoded is Map<String, dynamic>) {
        final Map<String, double> parsed = {};

        // Binance combined stream payload: { "stream": "...", "data": { "s": "BTCUSDT", "c": "..." } }
        final data = decoded['data'] is Map<String, dynamic>
            ? decoded['data'] as Map<String, dynamic>
            : decoded;

        final symbol = data['s']?.toString();
        final rawPrice = data['c']?.toString();

        if (symbol != null && rawPrice != null) {
          final price = double.tryParse(rawPrice);
          if (price != null) {
            parsed[symbol] = price;
          }
        } else {
          // Fallback key-value map
          for (final entry in decoded.entries) {
            final val = double.tryParse(entry.value.toString());
            if (val != null) {
              parsed[entry.key.toString()] = val;
            }
          }
        }

        if (parsed.isNotEmpty && !_pricesController.isClosed) {
          _pricesController.add(parsed);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[CryptoWsDataSource] Parsing error: $e');
      }
    }
  }

  void _onError(dynamic error) {
    if (kDebugMode) {
      debugPrint('[CryptoWsDataSource] Stream error: $error');
    }
    _emitStatus(WsStatus.failed(error.toString()));
    _scheduleReconnect();
  }

  void _onDone() {
    if (!_isManuallyClosed) {
      _emitStatus(const WsStatus.disconnected());
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_isManuallyClosed) return;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      if (!_isManuallyClosed && _currentIds.isNotEmpty) {
        connect(_currentIds);
      }
    });
  }

  void _emitStatus(WsStatus status) {
    if (!_statusController.isClosed) {
      _statusController.add(status);
    }
  }

  @override
  Future<void> disconnect() async {
    _isManuallyClosed = true;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    await _subscription?.cancel();
    _subscription = null;
    await _channel?.sink.close();
    _channel = null;
    _emitStatus(const WsStatus.disconnected());
  }

  void dispose() {
    disconnect();
    _pricesController.close();
    _statusController.close();
  }
}

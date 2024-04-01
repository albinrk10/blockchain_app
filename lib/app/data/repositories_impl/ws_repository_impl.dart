import 'dart:async';
import 'dart:convert';
import 'package:example2/app/domain/repositories/ws_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WsRepositoryImpl implements WsRepository {
  WsRepositoryImpl(this.builder);
  final WebSocketChannel Function(List<String>) builder;
  WebSocketChannel? _channel;
  StreamController<Map<String, double>>? _controller;
  StreamSubscription? _subscription;

  @override
  Future<bool> connect(List<String> ids) async {
    try {
      _channel = builder(ids);
      await _channel!.ready;
      _subscription = _channel!.stream.listen(
        (event) {
          final map = Map<String, String>.from(
            json.decode(event),
          );
          final data = <String, double>{}..addEntries(
            map.entries.map(
              (e) => MapEntry(
                e.key,
                double.parse(e.value),
              ),
            ),
          );
          if(_controller?.hasListener ?? false){
            _controller!.add(data);
          }
        },
      );
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  @override
  Future<void> disconnect() async {
    _subscription?.cancel();
    _controller?.close();
    await _channel?.sink.close();
    _channel = null;
  }
  
  @override
  Stream<Map<String, double>> get onPricesChanged {
    _controller ??= StreamController.broadcast();
    return _controller!.stream;
  }
}

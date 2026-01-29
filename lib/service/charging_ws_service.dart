import 'dart:convert';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChargingWsService {
  WebSocketChannel? _channel;
  StreamController<String>? _controller;

  void connect() {
    if (_channel != null) return;

    _channel = WebSocketChannel.connect(
      Uri.parse("ws://10.0.2.2:8083/ws/charging"),
    );

    _controller = StreamController<String>.broadcast();

    _channel!.stream.listen((message) {
      _controller!.add(message);
    });
  }

  Stream<String> get stream => _controller!.stream;

  void send(Map<String, dynamic> data) {
    _channel?.sink.add(jsonEncode(data));
  }

  void close() {
    _channel?.sink.close();
    _controller?.close();
    _channel = null;
    _controller = null;
  }
}

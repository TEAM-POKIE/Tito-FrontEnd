import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

final webSocketProvider = Provider<WebSocketService>((ref) {
  final service = WebSocketService();
  ref.onDispose(service.dispose);
  return service;
});

class WebSocketService {
  late final WebSocketChannel channel;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  WebSocketService() {
    channel =
        WebSocketChannel.connect(Uri.parse('ws://192.168.219.119:4040/ws/'));
    channel.stream.listen((message) {
      final decodedMessage = json.decode(message) as Map<String, dynamic>;
      _controller.sink.add(decodedMessage);
    });
  }

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  void sendMessage(Map<String, dynamic> message) {
    channel.sink.add(json.encode(message));
  }

  void dispose() {
    channel.sink.close(status.goingAway);
    _controller.close();
  }
}

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final webSocketProvider =
    Provider.family<WebSocketService, String>((ref, chatRoomId) {
  return WebSocketService('ws://10.21.20.62:4040/ws/$chatRoomId');
});

class WebSocketService {
  final WebSocketChannel channel;

  WebSocketService(String url)
      : channel = WebSocketChannel.connect(Uri.parse(url));

  void sendMessage(String message) {
    channel.sink.add(message);
  }

  void listen(void Function(String message) onMessage) {
    channel.stream.listen((message) {
      onMessage(message);
    });
  }

  void close() {
    channel.sink.close(status.goingAway);
  }
}

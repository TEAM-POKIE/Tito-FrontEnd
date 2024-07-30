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
  late WebSocketChannel channel;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  WebSocketService() {
    _connect();
  }

  void _connect() {
    try {
      channel = WebSocketChannel.connect(
          Uri.parse('wss://dev-tito.owsla.duckdns.org/ws/debate'));
      print('WebSocket connection established');

      channel.stream.listen((message) {
        try {
          print('Raw message received: $message');
          final decodedMessage = json.decode(message) as Map<String, dynamic>;
          print('Decoded message: $decodedMessage');
          _controller.sink.add(decodedMessage);
        } catch (e) {
          print('Error decoding message: $e');
        }
      }, onError: (error) {
        print('Error in websocket connection: $error');
        // _reconnect();
      }, onDone: () {
        print('WebSocket connection closed');
        // _reconnect();
      });
    } catch (e) {
      print('Error establishing WebSocket connection: $e');
      // _reconnect();
    }
  }

  // void _reconnect() {
  //   Future.delayed(Duration(seconds: 5), () {
  //     print('Attempting to reconnect...');
  //     _connect();
  //   });
  // }

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  // String 타입의 메시지도 처리할 수 있도록 수정
  void sendMessage(String message) {
    print('Sending message: $message');
    channel.sink.add(message);
  }

  void dispose() {
    channel.sink.close(status.goingAway);
    _controller.close();
  }
}

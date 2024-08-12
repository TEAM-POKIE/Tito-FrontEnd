import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:tito_app/src/data/models/types.dart' as types;

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
          Uri.parse('wss://dev-tito.owsla.mywire.org/ws/debate'));
      print('WebSocket connection established');

      channel.stream.listen((message) {
        try {
          print('Raw message received: $message');
          final decodedMessage = json.decode(message) as Map<String, dynamic>;
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

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  // messageStream 게터 추가
  Stream<List<types.Message>> get messageStream =>
      _controller.stream.map((data) {
        // 데이터를 Message 객체로 변환하는 로직 추가
        return (data['messages'] as List)
            .map((json) => types.Message.fromJson(json))
            .toList();
      });

  void sendMessage(String message) {
    print('Sending message: $message');
    channel.sink.add(message);
  }

  void dispose() {
    channel.sink.close(status.goingAway);
    _controller.close();
  }
}

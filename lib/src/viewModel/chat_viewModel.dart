import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/src/data/models/debate_info.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class ChatViewModel extends StateNotifier<DebateInfo?> {
  ChatViewModel() : super(null) {
    _connectWebSocket();
  }

  late WebSocketChannel _channel;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  // Debate 정보를 가져오는 메소드
  Future<void> fetchDebateInfo(int id) async {
    try {
      final debateInfo = await ApiService(DioClient.dio).getDebateInfo(id);
      state = debateInfo;
    } catch (error) {
      print('Error fetching debate info: $error');
      state = null;
    }
  }

  void _connectWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://dev-tito.owsla.duckdns.org/ws/debate'),
    );

    _channel.stream.listen((message) {
      final decodedMessage = json.decode(message) as Map<String, dynamic>;
      _messageController.sink.add(decodedMessage);
    }, onError: (error) {
      print('WebSocket error: $error');
    }, onDone: () {
      print('WebSocket connection closed');
    });
  }

  void sendMessage(String message) {
    _channel.sink.add(message);
  }

  void clear() {
    state = null;
  }

  @override
  void dispose() {
    _channel.sink.close(status.goingAway);
    _messageController.close();
    super.dispose();
  }
}

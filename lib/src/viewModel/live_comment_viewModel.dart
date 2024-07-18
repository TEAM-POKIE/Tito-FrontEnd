import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:http/http.dart' as http;

class LiveCommentViewModel extends StateNotifier<LiveState> {
  final WebSocketChannel channel;
  final TextEditingController controller = TextEditingController();
  final StreamController<List<Message>> _messagesController =
      StreamController.broadcast();
  final String roomId;

  LiveCommentViewModel(this.channel, this.roomId) : super(LiveState()) {
    fetchInitialMessages();
    channel.stream.listen((message) {
      final parsedMessage = _parseMessage(message);
      if (parsedMessage != null) {
        state = state.copyWith(
          messages: [parsedMessage, ...state.messages],
        );
        _messagesController.add(state.messages);
      }
    });
  }

  Stream<List<Message>> get messagesStream => _messagesController.stream;

  Future<void> fetchInitialMessages() async {
    try {
      final response = await http.get(Uri.parse(
          'https://pokeeserver-default-rtdb.firebaseio.com/live_comments/$roomId.json'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final messages =
            data.entries.map((e) => Message.fromJson(e.value)).toList();
        state = state.copyWith(messages: messages);
        _messagesController.add(state.messages);
      } else {
        print('Failed to fetch messages: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  void sendMessage(String message) async {
    if (message.isNotEmpty) {
      final fullMessage = jsonEncode({'username': 'User', 'message': message});
      channel.sink.add(fullMessage);

      // Save message to API
      final response = await http.post(
        Uri.parse(
            'https://pokeeserver-default-rtdb.firebaseio.com/live_comments/$roomId.json'),
        headers: {'Content-Type': 'application/json'},
        body: fullMessage,
      );

      if (response.statusCode == 200) {
        // Local state update for immediate feedback
        final parsedMessage = _parseMessage(fullMessage);
        if (parsedMessage != null) {
          state = state.copyWith(
            messages: [parsedMessage, ...state.messages],
          );
          _messagesController.add(state.messages);
        }
      } else {
        print('Failed to save message: ${response.statusCode}');
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    channel.sink.close(status.goingAway);
    _messagesController.close();
    super.dispose();
  }

  Message? _parseMessage(String message) {
    try {
      final parsed = jsonDecode(message);
      return Message(username: parsed['username'], message: parsed['message']);
    } catch (e) {
      print('Error parsing message: $e');
      return null;
    }
  }
}

class LiveState {
  final List<Message> messages;

  LiveState({this.messages = const []});

  LiveState copyWith({List<Message>? messages}) {
    return LiveState(messages: messages ?? this.messages);
  }
}

class Message {
  final String username;
  final String message;

  Message({required this.username, required this.message});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      username: json['username'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'message': message,
    };
  }
}

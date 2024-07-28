import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/viewModel/live_comment_viewModel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

// WebSocketService 클래스를 관리하는 StateNotifierProvider 정의
final liveCommentProvider =
    StateNotifierProvider<LiveCommentViewModel, LiveState>(
  (ref) {
    final webSocketService = WebSocketService();
    return LiveCommentViewModel(webSocketService.channel);
  },
);

class WebSocketService {
  final WebSocketChannel channel;

  WebSocketService()
      : channel =
            WebSocketChannel.connect(Uri.parse('ws://192.168.1.6:4040/ws'));

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

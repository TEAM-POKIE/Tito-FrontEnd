import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/viewModel/live_comment_viewModel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

final liveCommentProvider =
    StateNotifierProvider.family<LiveCommentViewModel, LiveState, String>(
        (ref, roomId) {
  final webSocketService = WebSocketService('ws://10.21.20.62:4040/ws/$roomId');
  return LiveCommentViewModel(webSocketService.channel, roomId); // ref 추가
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

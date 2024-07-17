import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:tito_app/src/viewModel/live_comment_viewModel.dart';

final liveCommentProvider =
    StateNotifierProvider<LiveCommentViewModel, LiveState>((ref) {
  final channel = WebSocketChannel.connect(Uri.parse('ws://localhost:4000'));
  return LiveCommentViewModel(channel);
});

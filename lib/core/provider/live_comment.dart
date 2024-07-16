import 'package:riverpod/riverpod.dart';

import 'package:tito_app/src/viewModel/live_comment_viewModel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final liveCommentProvider =
    StateNotifierProvider<LiveCommentViewmodel, LiveState>((ref) {
  final channel = WebSocketChannel.connect(Uri.parse('ws://localhost:4040/ws'));
  return LiveCommentViewmodel(channel);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:tito_app/src/viewModel/live_comment_viewModel.dart';

final liveCommentProvider =
    StateNotifierProvider.family<LiveCommentViewModel, LiveState, String>(
        (ref, roomId) {
  final channel =
      WebSocketChannel.connect(Uri.parse('ws://localhost:4040/ws/$roomId'));

  return LiveCommentViewModel(channel, roomId);
});

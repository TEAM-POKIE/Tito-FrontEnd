import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/view/chatView/chat_bottom_detail.dart';

import 'package:tito_app/src/view/chatView/chat_list_view.dart';
import 'package:tito_app/src/view/chatView/chat_speech_bubble.dart';
import 'package:tito_app/src/view/chatView/chat_view_details.dart';

class ChatBody extends ConsumerWidget {
  const ChatBody({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // ChatViewDetails(), // id 전달

        // Expanded(
        //   child: ChatListView(),
        // ),

        // ChatSpeechBubble(),

        // ChatBottomDetail(), // id 전달
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/src/view/chatView/chat_bottom_detail.dart';
import 'package:tito_app/src/view/chatView/chat_list_view.dart';
import 'package:tito_app/src/view/chatView/chat_speech_bubble.dart';
import 'package:tito_app/src/view/chatView/chat_view_details.dart';

class ChatBody extends ConsumerWidget {
  final int id;

  const ChatBody({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ChatViewDetails(id: id), // id 전달
        Expanded(
          child: Container(
              decoration: BoxDecoration(color: ColorSystem.grey3),
              child: ChatListView(id: id)), // id 전달
        ),
        Container(
          // 여기가 그 입력바 클릭시 뜨는 윗 공간임
          child: ChatSpeechBubble(),
          decoration: BoxDecoration(
            color: ColorSystem.lightPurple,
          ),
        ),
        ChatBottomDetail(id: id), // id 전달
      ],
    );
  }
}

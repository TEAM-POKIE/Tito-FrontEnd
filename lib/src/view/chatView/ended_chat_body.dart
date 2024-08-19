import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/src/view/chatView/chat_bottom_detail.dart';
import 'package:tito_app/src/view/chatView/chat_list_view.dart';
import 'package:tito_app/src/view/chatView/chat_speech_bubble.dart';
import 'package:tito_app/src/view/chatView/chat_view_details.dart';
import 'package:tito_app/src/view/chatView/ended_chat_list.dart';
import 'package:tito_app/src/view/chatView/votingbar.dart';

class EndedChatBody extends ConsumerWidget {
  final int id;

  const EndedChatBody({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ChatViewDetails(id: id),
        VotingBar(),
        Expanded(
          child: Container(
              decoration: BoxDecoration(color: ColorSystem.grey3),
              child: EndedChatList(id: id)), // id 전달
        ),
      ],
    );
  }
}

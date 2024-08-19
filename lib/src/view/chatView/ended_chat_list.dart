import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/ended_provider.dart';
import 'package:tito_app/src/data/models/ended_chat.dart';

class EndedChatList extends ConsumerStatefulWidget {
  final int id;

  EndedChatList({
    super.key,
    required this.id,
  });

  @override
  _EndedChatListState createState() => _EndedChatListState();
}

class _EndedChatListState extends ConsumerState<EndedChatList> {
  List<EndedChatInfo> messages = [];
  int? myUserId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final endedViewModel = ref.read(endedProvider.notifier);
      final response = await endedViewModel.getChat(widget.id);

      if (response.isNotEmpty) {
        setState(() {
          messages = response; // response를 messages에 저장
          myUserId = messages.first.userId; // 첫 번째 메시지의 userId를 기준으로 설정
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: messages.length + 1, // messages 길이 + 1
            itemBuilder: (context, index) {
              if (index == messages.length) {
                // 마지막 아이템에 "토론이 종료되었습니다" 추가
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Center(
                    child: Text(
                      '토론이 종료되었습니다.',
                      style:
                          FontSystem.KR14R.copyWith(color: ColorSystem.grey1),
                    ),
                  ),
                );
              }

              final message = messages[index];
              final isMyMessage = message.userId == myUserId;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: isMyMessage
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!isMyMessage)
                          CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: isMyMessage
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Container(
                              constraints: BoxConstraints(maxWidth: 250),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              decoration: BoxDecoration(
                                color: ColorSystem.white,
                                borderRadius: isMyMessage
                                    ? BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                        bottomLeft: Radius.circular(16),
                                      )
                                    : BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                        bottomRight: Radius.circular(16),
                                      ),
                              ),
                              child: Text(
                                message.content,
                                style: FontSystem.KR14R,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              TimeOfDay.fromDateTime(
                                      DateTime.parse(message.createdAt))
                                  .format(context),
                              style: FontSystem.KR12R
                                  .copyWith(color: ColorSystem.grey1),
                            ),
                          ],
                        ),
                        if (isMyMessage) SizedBox(width: 10),
                        if (isMyMessage)
                          CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

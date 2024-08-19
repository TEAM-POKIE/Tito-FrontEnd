import 'package:flutter/material.dart';
import 'package:tito_app/core/constants/style.dart';

class EndedChatList extends StatelessWidget {
  final List<Map<String, dynamic>> messages = [
    {
      'userId': 1,
      'content':
          '저는 외계인이 있다고 생각해요 왜냐하면 블라 블라블라블라블라블라블라블라 블라 블라블라블라블라블라블라블라 블라 블라블라블라블라블라블라블라',
      'createdAt': DateTime.now(),
      'command': 'CHAT',
    },
    {
      'userId': 2,
      'content':
          '저는 외계인이 없다고 생각해요 왜냐하면 블라 블라블라블라블라블라블라블라 블라 블라블라블라블라블라블라블라 블라 블라블라블라블라블라블라블라',
      'createdAt': DateTime.now(),
      'command': 'CHAT',
    },
    {
      'userId': 1,
      'content':
          '저는 외계인이 있다고 생각해요 왜냐하면 블라 블라블라블라블라블라블라블라 블라 블라블라블라블라블라블라블라 블라 블라블라블라블라블라블라블라',
      'createdAt': DateTime.now(),
      'command': 'CHAT',
    },
    {
      'userId': 2,
      'content':
          '저는 외계인이 없다고 생각해요 왜냐하면 블라 블라블라블라블라블라블라블라 블라 블라블라블라블라블라블라블라 블라 블라블라블라블라블라블라블라',
      'createdAt': DateTime.now(),
      'command': 'CHAT',
    },
  ];

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
              final isMyMessage = message['userId'] == 1; // User ID 1이 나라고 가정

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
                                message['content'],
                                style: FontSystem.KR14R,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              TimeOfDay.fromDateTime(message['createdAt'])
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

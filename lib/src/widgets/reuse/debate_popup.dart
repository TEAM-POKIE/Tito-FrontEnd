import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

import 'package:go_router/go_router.dart';

class DebatePopup extends ConsumerWidget {
  final String debateId;
  final String nick;
  final Function onUpdate;

  DebatePopup(
      {required this.debateId, required this.nick, required this.onUpdate});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Icon(Icons.person, color: Colors.grey),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '토론에 참여 하시겠어요?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '작성하신 의견을 전송하면\n토론 개설자에게 보여지고\n토론이 본격적으로 시작돼요!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final url = Uri.https('pokeeserver-default-rtdb.firebaseio.com',
                    'debate_list/$debateId.json');

                final response = await http.patch(url,
                    headers: {
                      'Content-Type': 'application/json',
                    },
                    body: json.encode({
                      'opponentNick': nick,
                    }));

                if (response.statusCode == 200) {
                  onUpdate(nick);
                  context.pop();
                } else {
                  print('Failed to update opponentNick: ${response.body}');
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text('토론 참여하기'),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xff8E48F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '의견을 작성해보세요 !',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

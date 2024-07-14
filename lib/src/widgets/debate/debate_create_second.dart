import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/provider/debate_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DebateCreateSecond extends ConsumerStatefulWidget {
  const DebateCreateSecond({super.key});

  @override
  ConsumerState<DebateCreateSecond> createState() => _DebateCreateSecondState();
}

class _DebateCreateSecondState extends ConsumerState<DebateCreateSecond> {
  final _formKey = GlobalKey<FormState>();
  var myArguments = '';
  var opponentArguments = '';

  Future<String> _createDebateRoom() async {
    final debateInfo = ref.read(debateInfoProvider);
    final loginInfo = ref.read(loginInfoProvider);
    final url = Uri.https(
        'pokeeserver-default-rtdb.firebaseio.com', 'debate_list.json');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'title': debateInfo?.title ?? '',
          'category': debateInfo?.category ?? '',
          'myArgument': debateInfo?.myArgument ?? '',
          'myNick': loginInfo?.nickname ?? '',
          'turnId': '',
          'opponentArgument': debateInfo?.opponentArgument ?? '',
          'opponentNick': debateInfo?.opponentNick ?? '',
          'debateState': debateInfo?.debateState ?? '',
          'timestamp': DateTime.now().toIso8601String(),
          'visibleDebate': false,
        }));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['name']; // Firebase는 새로 생성된 리소스의 키를 'name' 필드로 반환합니다.
    } else {
      throw Exception('Failed to create debate room');
    }
  }

  void _navigateToChat(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    final loginInfo = ref.read(loginInfoProvider);

    ref.read(debateInfoProvider.notifier).updateDebateInfo(
          myArgument: myArguments,
          opponentArgument: opponentArguments,
          myNick: loginInfo!.nickname,
        );

    try {
      final newChatId = await _createDebateRoom();
      final debateInfo = ref.read(debateInfoProvider);

      context.push('/chat/$newChatId');
    } catch (e) {
      print('Error creating debate room: $e');
      // Handle error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    final debateInfo = ref.watch(debateInfoProvider);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: LinearPercentIndicator(
                  width: 200,
                  animation: true,
                  animationDuration: 200,
                  lineHeight: 5.0,
                  percent: 1,
                  linearStrokeCap: LinearStrokeCap.butt,
                  progressColor: const Color(0xff8E48F8),
                  backgroundColor: Colors.grey,
                  barRadius: const Radius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                debateInfo?.title ?? '',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),
              const Text(
                '나의 주장',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              TextFormField(
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: '입력하세요',
                  fillColor: Colors.grey[200],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '나의 주장을 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  myArguments = value!;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                '상대 주장',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              TextFormField(
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: '입력하세요',
                  fillColor: Colors.grey[200],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '상대 주장을 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  opponentArguments = value!;
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _navigateToChat(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff8E48F8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    '토론방으로 이동',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

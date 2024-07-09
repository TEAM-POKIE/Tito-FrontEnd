import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/provider/debate_provider.dart';
import 'package:tito_app/provider/login_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tito_app/provider/nav_provider.dart';
import 'package:tito_app/screen/list_screen.dart';
import 'package:tito_app/widgets/debate/debate_writer.dart';

class DebateCreateSecond extends ConsumerStatefulWidget {
  const DebateCreateSecond({super.key});

  @override
  ConsumerState<DebateCreateSecond> createState() => _DebateCreateSecondState();
}

class _DebateCreateSecondState extends ConsumerState<DebateCreateSecond> {
  final _formKey = GlobalKey<FormState>();
  var myArguments = '';
  var opponentArguments = '';

  void _createDebateRoom() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    final loginInfo = ref.read(loginInfoProvider);
    ref.read(debateInfoProvider.notifier).updateDebateInfo(
          myArgument: myArguments,
          opponentArgument: opponentArguments,
        );

    final url =
        Uri.https('tito-f8791-default-rtdb.firebaseio.com', 'debate_list.json');
    final debateInfo = ref.read(debateInfoProvider);
    final currentTime = DateTime.now().toIso8601String();

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'title': debateInfo?.title,
          'category': debateInfo?.category,
          'myArgument': debateInfo?.myArgument,
          'myId': loginInfo?.email,
          'opponentArgument': debateInfo?.opponentArgument,
          'opponentId': debateInfo?.opponentId,
          'debateState': debateInfo?.debateState,
          'timestamp': currentTime,
        }));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final debateId = responseData['name']; // Firebase에서 생성된 debateId

      ref.read(selectedIndexProvider.notifier).state = 1;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => DebateWriter(debateId: debateId)),
        (Route<dynamic> route) => false,
      );
    } else {
      // 에러 처리
      print('Failed to create debate room: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final debateInfo = ref.watch(debateInfoProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0), // 원하는 여백 크기
          child: LinearProgressIndicator(
            value: 1,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
          ), // 나중에 마무리
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
                  onPressed: _createDebateRoom,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff8E48F8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    '토론방 개설',
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/provider/debate_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/provider/login_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DebateCreateSecond extends ConsumerStatefulWidget {
  const DebateCreateSecond({super.key});

  @override
  ConsumerState<DebateCreateSecond> createState() => _DebateCreateSecondState();
}

class _DebateCreateSecondState extends ConsumerState<DebateCreateSecond> {
  final _formKey = GlobalKey<FormState>();
  var myArguments = '';
  var opponentArguments = '';

  void _navigateToChat(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    final loginInfo = ref.read(loginInfoProvider);
    ref.read(debateInfoProvider.notifier).updateDebateInfo(
          myArgument: myArguments,
          opponentArgument: opponentArguments,
        );

    final debateInfo = ref.read(debateInfoProvider);

    context.go('/chat', extra: {
      'title': debateInfo?.title ?? '',
      'id': '',
      'myId': loginInfo?.email ?? '',
      'opponentId': debateInfo?.opponentId ?? '',
    });
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

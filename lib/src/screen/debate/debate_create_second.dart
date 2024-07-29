import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tito_app/core/provider/debate_create_provider.dart';

class DebateCreateSecond extends ConsumerStatefulWidget {
  const DebateCreateSecond({super.key});

  @override
  ConsumerState<DebateCreateSecond> createState() => _DebateCreateSecondState();
}

class _DebateCreateSecondState extends ConsumerState<DebateCreateSecond> {
  final _formKey = GlobalKey<FormState>();
  String aArgument = '';
  String bArgument = '';

  @override
  Widget build(BuildContext context) {
    final debateViewModel = ref.read(debateCreateProvider.notifier);
    final debateState = ref.watch(debateCreateProvider);

    void _nextCreate(BuildContext context) async {
      if (!debateViewModel.validateForm(_formKey)) {
        return;
      }
      _formKey.currentState?.save(); // 폼의 모든 필드 저장
      print('aArgument: $aArgument');
      print('bArgument: $bArgument');
      debateViewModel.updateOpinion(aArgument, bArgument);

      if (!context.mounted) return;

      context.push('/debate_create_third');
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 키보드 내리기
      },
      child: Scaffold(
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    debateState.debateTitle,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
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
                      aArgument = value ?? '';
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
                      bArgument = value ?? '';
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _nextCreate(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff8E48F8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text(
                '다음',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

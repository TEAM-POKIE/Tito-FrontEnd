import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/debate_create_provider.dart';

class DebateCreateThird extends ConsumerWidget {
  const DebateCreateThird({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    final debateViewModel = ref.watch(debateCreateProvider.notifier);
    final debateState = ref.watch(debateCreateProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss keyboard
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: LinearProgressIndicator(
                    value: 1.0,
                    backgroundColor: Colors.grey[300],
                    color: const Color(0xff8E48F8),
                  ),
                ),
              ),
            ],
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
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
                    style: FontSystem.KR18B.copyWith(fontSize: 30),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '토론 주제에 대한 본문',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    autocorrect: false,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: '입력하세요',
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '본문을 입력하세요';
                      }
                      return null;
                    },
                    // onSaved: (value) {
                    //   debateViewModel.updateContent(value ?? '');
                    // },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '이미지 첨부하기',
                    style: FontSystem.KR18R.copyWith(color: ColorSystem.black),
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {}, //debateViewModel.pickImage,
                        icon: const Icon(
                          Icons.camera_alt,
                          color: ColorSystem.white,
                        ),
                        label: Text(
                          '파일 첨부',
                          style: FontSystem.KR14M
                              .copyWith(color: ColorSystem.white),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: ColorSystem.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ],
                  ),
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
              onPressed: () {
                debateViewModel.nextChat(_formKey, context);
              },
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

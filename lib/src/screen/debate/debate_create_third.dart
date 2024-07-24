import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebateCreateThird extends ConsumerStatefulWidget {
  const DebateCreateThird({super.key});

  @override
  ConsumerState<DebateCreateThird> createState() => _DebateCreateThirdState();
}

class _DebateCreateThirdState extends ConsumerState<DebateCreateThird> {
  final _formKey = GlobalKey<FormState>();
  String debateTopic = '';

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    // 필요한 작업 수행
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 키보드 내리기
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  '연인이 대머리가 되어도 만날 수 있다?',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: '토론 주제에 대한 본문',
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '본문을 입력하세요';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    debateTopic = value!;
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  '이미지 첨부하기',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    // 파일 선택 기능 구현
                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text('파일 첨부'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff8E48F8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff8E48F8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: Text(
                      '다음',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tito_app/screen/home_screen.dart';

class BasicLogin extends StatefulWidget {
  const BasicLogin({super.key});

  @override
  State<BasicLogin> createState() {
    return _BasicLoginState();
  }
}

class _BasicLoginState extends State<BasicLogin> {
  final _formKey = GlobalKey<FormState>();

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey, // Form에 key 설정
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('이메일'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력해주세요';
                  }
                  // 이메일 형식 확인
                  // final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                  // if (!emailRegex.hasMatch(value)) {
                  //   return '유효한 이메일 주소를 입력해주세요';
                  // }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                maxLength: 20,
                decoration: const InputDecoration(
                  label: Text('비밀번호'),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해주세요';
                  }
                  // if (value.length < 8) {
                  //   return '비밀번호는 8자 이상이어야 합니다';
                  // }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                onPressed: _onLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(300, 60),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10), // 버튼 내부의 패딩 설정
                  // 텍스트 스타일 설정
                ),
                child: const Text(
                  '로그인',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

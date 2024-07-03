import 'package:flutter/material.dart';
import 'package:tito_app/widgets/login/login_main.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  void _goLoginMain(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const LoginMain(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xff8E48F8), // 배경색을 보라색으로 설정
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '티',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '키타카 '),
                    TextSpan(
                      text: '토',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '론하기'),
                  ],
                ),
                style: TextStyle(fontSize: 24), // 기본 텍스트 스타일
              ),
              ElevatedButton(
                onPressed: () => _goLoginMain(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(300, 60),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10), // 버튼 내부의 패딩 설정
                  // 텍스트 스타일 설정
                ),
                child: const Text(
                  '시작하기',
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

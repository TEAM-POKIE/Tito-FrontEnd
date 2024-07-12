import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/widgets/login/basic_login.dart';
import 'package:tito_app/widgets/login/signup.dart';

class LoginMain extends StatelessWidget {
  const LoginMain({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> loginOptions = [
      {
        'text': '카카오 로그인',
        'image': 'assets/images/kakao.png',
      },
      {
        'text': '구글로 로그인',
        'image': 'assets/images/google.png',
      },
      {
        'text': '애플로 로그인',
        'image': 'assets/images/apple.png',
      },
    ];

    void _goBasicLogin() {
      context.push('/basicLogin');
    }

    void _goSignuUp() {
      context.push('/signup');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff8E48F8), // AppBar 배경색 설정
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: const Color(0xff8E48F8), // 배경색을 보라색으로 설정
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xff8E48F8), // 배경색을 보라색으로 설정
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...loginOptions.map((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Image.asset(
                      option['image']!,
                      width: 24,
                      height: 24,
                    ),
                    label: Text(option['text']!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.white.withOpacity(0.2), // 투명 흰색 배경 설정
                      foregroundColor: Colors.black,
                      minimumSize: const Size(300, 60),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10), // 버튼 내부의 패딩 설정
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 20), // 버튼들 간의 간격 추가
              ElevatedButton(
                onPressed: _goBasicLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(300, 60),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10), // 버튼 내부의 패딩 설정
                  textStyle: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ), // 텍스트 스타일 설정
                ),
                child: const Text(
                  '로그인',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('아직 회원이 아니신가요?'),
                  TextButton(
                    onPressed: _goSignuUp,
                    child: const Text(
                      '회원가입',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

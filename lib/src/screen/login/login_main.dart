import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';

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

    void goBasicLogin() {
      context.push('/basicLogin');
    }

    void goSignuUp() {
      context.push('/signup');
    }

    return Scaffold(
      backgroundColor: ColorSystem.purple, // 배경색을 보라색으로 설정
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/splashs.png',
                width: MediaQuery.sizeOf(context).width * 0.4,
              ),
              const SizedBox(height: 40),
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
                      backgroundColor: Color(0xffA56DF9),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(300, 60),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10), // 버튼 내부의 패딩 설정
                      side: const BorderSide(color: ColorSystem.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      textStyle: FontSystem.KR16B,
                    ),
                  ),
                );
              }),
              SizedBox(height: 12.h), // 버튼들 간의 간격 추가
              ElevatedButton(
                onPressed: goBasicLogin,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  backgroundColor: ColorSystem.black,
                  //minimumSize: const Size(300, 60),
                  padding: EdgeInsets.symmetric(
                      horizontal: 103.w, vertical: 18.h), // 버튼 내부의 패딩 설정
                ),
                child: Text(
                  '로그인',
                  style: FontSystem.KR18B.copyWith(color: ColorSystem.white),
                ),
              ),
              SizedBox(height: 64.h), // 버튼들 간의 간격 추가
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '아직 회원이 아니신가요?',
                    style: FontSystem.KR14R,
                  ),
                  TextButton(
                    onPressed: goSignuUp,
                    child: Text(
                      '회원가입',
                      style: FontSystem.KR14B.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50.h)
            ],
          ),
        ),
      ),
    );
  }
}

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
        'text': '카카오로 시작하기',
        'image': 'assets/images/kakao.png',
      },
      {
        'text': '구글로 시작하기',
        'image': 'assets/images/google.png',
      },
      {
        'text': '애플로 시작하기',
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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 146.h),
            Image.asset(
              'assets/images/splashs.png',
              width: 162.w,
              height: 127.29.h,
            ),
            SizedBox(height: 102.h),
            ...loginOptions.map((option) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h, left: 32.w, right: 32.w),
                child: Container(
                  width: 326.w,
                  height: 60.h,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Image.asset(
                      option['image']!,
                      width: 24.r,
                      height: 24.r,
                    ),
                    label: Text(option['text']!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorSystem.loginPurple,
                      foregroundColor: ColorSystem.white,
                      // padding: EdgeInsets.symmetric(
                      //     horizontal: 103.w, vertical: 18.h), // 버튼 내부의 패딩 설정
                      side: const BorderSide(color: ColorSystem.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      textStyle: FontSystem.KR16R,
                    ),
                  ),
                ),
              );
            }),
            SizedBox(height: 10.h), // 버튼들 간의 간격 추가
            Container(
              width: 326.w,
              height: 60.h,
              child: ElevatedButton(
                onPressed: goBasicLogin,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  backgroundColor: ColorSystem.black,
                  //minimumSize: const Size(300, 60),
                  // padding: EdgeInsets.symmetric(
                      // horizontal: 140.w, vertical: 17.h), // 버튼 내부의 패딩 설정
                ),
                child: Text(
                  '로그인',
                  style: FontSystem.KR16B.copyWith(color: ColorSystem.white),
                ),
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
            SizedBox(height: 16.h)
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

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

    void goSignUp() {
      context.push('/signup');
    }

    Future<void> _signInWithGoogle() async {
      // ! Google OAUTH 설정 로드
      const FlutterAppAuth appAuth = FlutterAppAuth();
      // const FlutterSecureStorage secureStorage = FlutterSecureStorage();
      final String clientId = dotenv.env['OAUTH_GOOGLE_CLIENT_ID']!;
      final String redirectUri = dotenv.env['OAUTH_GOOGLE_REDIRECT_URI']!;

      final AuthorizationServiceConfiguration serviceConfiguration =
          AuthorizationServiceConfiguration(
        authorizationEndpoint:
            dotenv.env['OAUTH_GOOGLE_AUTHORIZATION_ENDPOINT']!,
        tokenEndpoint: dotenv.env['OAUTH_GOOGLE_TOKEN_ENDPOINT']!,
      );
      const List<String> scopes = ['openid', 'email', 'profile'];
      debugPrint("pushpush");

      try {
        log("pushed");
        final AuthorizationTokenResponse? result =
            await appAuth.authorizeAndExchangeCode(
          AuthorizationTokenRequest(
            clientId,
            redirectUri,
            serviceConfiguration: serviceConfiguration,
            scopes: scopes,
          ),
        );

        if (result != null) {
          final String accessToken = result.accessToken!;
          final String idToken = result.idToken!;
          debugPrint(accessToken);
          debugPrint("pushpush");
          debugPrint(idToken);
          debugPrint("pushpush");

          // Phase 1. SecureStorage에 token 저장
          await secureStorage.write(key: 'access_token', value: accessToken);
          await secureStorage.write(key: 'id_token', value: idToken);

          debugPrint("시큐어 씀");
          debugPrint(await secureStorage.read(key: 'access_token'));
          debugPrint(await secureStorage.read(key: 'id_token'));

          // Phase 2. Backend에 토큰 보내서 확인받음
          // TODO: Code here

          // Phase 3. 성공한 경우
          // Case 3.1. 최초 회원인 경우 부족한 정보 작성 페이지로 이동
          // TODO: Code here

          // Case 3.2. 기존 회원인 경우 메인 페이지로 리다이렉트
          // TODO: Code here
        }
      } catch (e) {
        // 에러 처리
        debugPrint('Error during authentication: $e');
      }
    }

    Future<void> _signInWithKaKao() async {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        debugPrint('카카오톡으로 로그인 성공 ${token.accessToken}');
        // Phase 1. SecureStorage에 token 저장
        await secureStorage.write(
            key: 'access_token', value: token.accessToken);
        await secureStorage.write(key: 'id_token', value: token.idToken);

        // Phase 2. Backend에 토큰 보내서 확인받음
        // TODO: Code here

        // Phase 3. 성공한 경우
        // Case 3.1. 최초 회원인 경우
        // TODO: Code here

        // Case 3.2. 기존 회원인 경우 메인 페이지로 리다이렉트
        // TODO: Code here
      } catch (error) {
        debugPrint('카카오톡으로 로그인 실패 $error');
      }
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
                  onPressed: goSignUp,
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

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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

class LoginMain extends StatelessWidget {
  const LoginMain({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> loginOptions = [
      {
        'icon': 'assets/icons/kakao_size.svg',
      },
      {
        'icon': 'assets/icons/apple_size.svg',
      },
      {
        'icon': 'assets/icons/google_size.svg',
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
                padding: EdgeInsets.only(bottom: 10.h, left: 32.w, right: 32.w),
                child: Container(
                  width: 327.w,
                  height: 54.h,
                  child: GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset(
                      option['icon']!,
                    ),
                  ),
                ),
              );
            }),
            Container(
              width: 327.w,
              height: 54.h,
              child: GestureDetector(
                onTap: goBasicLogin,
                child: SvgPicture.asset('assets/icons/email_real.svg'),
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

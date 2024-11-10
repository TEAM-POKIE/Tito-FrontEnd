import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:url_launcher/url_launcher.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

class LoginMain extends ConsumerWidget {
  const LoginMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime? lastBackPressedTime;

    Future<bool> _onWillPop(BuildContext context) async {
      if (lastBackPressedTime == null ||
          DateTime.now().difference(lastBackPressedTime!) >
              Duration(seconds: 2)) {
        lastBackPressedTime = DateTime.now();
        Fluttertoast.showToast(msg: '뒤로 가기를 한번 더 누르면 종료됩니다.');
        return false;
      } else {
        return true;
      }
    }

    void goBasicLogin() {
      context.push('/basicLogin');
    }

    void goSignUp() {
      context.push('/signup');
    }

    Future<void> _signInWithGoogle() async {
      // GoogleSignIn 객체 생성
      final _googleSignIn = GoogleSignIn();

      try {
        // Phase 1. 사용자 인증
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          // 사용자가 로그인 취소한 경우
          debugPrint('User canceled Google Sign-In');
          return;
        }

        // Phase 2. 인증 정보 가져오기
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final String accessToken = googleAuth.accessToken!;
        final String idToken = googleAuth.idToken!;

        // Phase 3. SecureStorage에 token 저장
        const FlutterSecureStorage secureStorage = FlutterSecureStorage();
        await secureStorage.write(key: 'access_token', value: accessToken);
        await secureStorage.write(key: 'id_token', value: idToken);

        // Phase 4. Backend에 토큰 보내서 확인받음
        final String fcmToken =
            await FirebaseMessaging.instance.getToken() ?? '';
        final authResponse = await ApiService(DioClient.dio).oAuthGoogle({
          "accessToken": accessToken,
          'fcmToken': fcmToken,
        });

        // Phase 5. 마이데이터 조회, nickname 유무 확인
        await DioClient.setToken(authResponse.accessToken.token);
        final userInfo = await ApiService(DioClient.dio).getUserInfo();
        final loginInfoNotifier = ref.read(loginInfoProvider.notifier);
        loginInfoNotifier.setLoginInfo(userInfo);
        if (userInfo.nickname == "") {
          debugPrint('TODO: NEW : empty user nickname');
          // TODO: 닉네임 설정 페이지로 이동
        } else {
          debugPrint("TODO: OLD : go to main");
          // TODO: 메인 페이지로 이동
        }

        // Phase 6. 홈 화면으로 이동
        if (!context.mounted) return;
        context.go('/home');
      } catch (e) {
        debugPrint('Error during Google Sign-In: $e');
      }
    }

    Future<void> _signInWithKaKao() async {
      if (await isKakaoTalkInstalled()) {
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
          debugPrint('카카오톡으로 로그인 성공 ${token.accessToken}');

          await secureStorage.write(
              key: 'access_token', value: token.accessToken);
          await secureStorage.write(key: 'id_token', value: token.idToken);
          debugPrint(token.accessToken);

          // & Phase 3. Backend에 토큰 보내서 확인받음
          final authResponse = await ApiService(DioClient.dio).oAuthKakao({
            "accessToken": token.accessToken,
            'fcmToken': await FirebaseMessaging.instance.getToken() ?? ''
          });

          // & Phase 4. 성공한 경우 마이데이터 조회, nickname 유무 확인
          await DioClient.setToken(authResponse.accessToken.token);
          // Case 4.1. 마이데이터 조회 결과 nickname이 null인 경우 해당 페이지로 이동
          final userInfo = await ApiService(DioClient.dio).getUserInfo();

          final loginInfoNotifier = ref.read(loginInfoProvider.notifier);
          loginInfoNotifier.setLoginInfo(userInfo);
          if (userInfo.nickname == "") {
            debugPrint('TODO: NEW : 카카오 empty user nickname');
          }
          // Case 3.2. 기존 회원인 경우 메인 페이지로 리다이렉트
          else {
            debugPrint("TODO: OLD : 기존 go to main");
          }
          // & Phase 4. HomeScreen으로 이동
          if (!context.mounted) return;
          context.go('/home');
        } catch (error) {
          print('카카오톡으로 로그인 실패 $error');

          // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
          // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
          if (error is PlatformException && error.code == 'CANCELED') {
            return;
          }
          // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
          try {
            await UserApi.instance.loginWithKakaoAccount();
            print('카카오계정으로 로그인 성공');
            OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
            debugPrint('카카오톡으로 로그인 성공 ${token.accessToken}');

            await secureStorage.write(
                key: 'access_token', value: token.accessToken);
            await secureStorage.write(key: 'id_token', value: token.idToken);
            debugPrint(token.accessToken);

            // & Phase 3. Backend에 토큰 보내서 확인받음
            final authResponse = await ApiService(DioClient.dio).oAuthKakao({
              "accessToken": token.accessToken,
              'fcmToken': await FirebaseMessaging.instance.getToken() ?? ''
            });

            // & Phase 4. 성공한 경우 마이데이터 조회, nickname 유무 확인
            await DioClient.setToken(authResponse.accessToken.token);
            // Case 4.1. 마이데이터 조회 결과 nickname이 null인 경우 해당 페이지로 이동
            final userInfo = await ApiService(DioClient.dio).getUserInfo();
            final loginInfoNotifier = ref.read(loginInfoProvider.notifier);
            loginInfoNotifier.setLoginInfo(userInfo);
            if (userInfo.nickname == "") {
              debugPrint('TODO: NEW : 카카오 empty user nickname');
            }
            // Case 3.2. 기존 회원인 경우 메인 페이지로 리다이렉트
            else {
              debugPrint("TODO: OLD : 기존 go to main");
            }
            // & Phase 4. HomeScreen으로 이동
            if (!context.mounted) return;
            context.go('/home');
          } catch (error) {
            print('카카오계정으로 로그인 실패 $error');
          }
        }
      } else {
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
          debugPrint('카카오톡으로 로그인 성공 ${token.accessToken}');

          await secureStorage.write(
              key: 'access_token', value: token.accessToken);
          await secureStorage.write(key: 'id_token', value: token.idToken);
          debugPrint(token.accessToken);

          // & Phase 3. Backend에 토큰 보내서 확인받음
          final authResponse = await ApiService(DioClient.dio).oAuthKakao({
            "accessToken": token.accessToken,
            'fcmToken': await FirebaseMessaging.instance.getToken() ?? ''
          });

          // & Phase 4. 성공한 경우 마이데이터 조회, nickname 유무 확인
          await DioClient.setToken(authResponse.accessToken.token);
          // Case 4.1. 마이데이터 조회 결과 nickname이 null인 경우 해당 페이지로 이동
          final userInfo = await ApiService(DioClient.dio).getUserInfo();
          final loginInfoNotifier = ref.read(loginInfoProvider.notifier);
          loginInfoNotifier.setLoginInfo(userInfo);
          if (userInfo.nickname == "") {
            debugPrint('TODO: NEW : 카카오 empty user nickname');
          }
          // Case 3.2. 기존 회원인 경우 메인 페이지로 리다이렉트
          else {
            debugPrint("TODO: OLD : 기존 go to main");
          }
          // & Phase 4. HomeScreen으로 이동
          if (!context.mounted) return;
          context.go('/home');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    }

    Future<void> _signInWithApple() async {
      try {
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
              clientId: 'titoApp.example.com', // 서비스 ID에 해당하는 clientId
              // TODO: 이거 수정 안했는데 잘 작동 됨. 추후 확인 필요.
              redirectUri: Uri.parse('https://dev.tito.lat/oauth/apple')),
          nonce: 'example-nonce',
          state: 'example-state',
        );

        if (credential != null) {
          // & Phase 3. Backend에 토큰 보내서 확인받음
          final authResponse = await ApiService(DioClient.dio).oAuthApple({
            "accessToken": credential.identityToken!,
            'fcmToken': await FirebaseMessaging.instance.getToken() ?? ''
          });

          // & Phase 4. 성공한 경우 마이데이터 조회, nickname 유무 확인
          await DioClient.setToken(authResponse.accessToken.token);
          // Case 4.1. 마이데이터 조회 결과 nickname이 null인 경우 해당 페이지로 이동
          final userInfo = await ApiService(DioClient.dio).getUserInfo();
          if (userInfo.nickname == "") {
            debugPrint('TODO: NEW : APPLE empty user nickname');
          }
          // Case 3.2. 기존 회원인 경우 메인 페이지로 리다이렉트
          else {
            debugPrint("TODO: OLD : APPLE 기존 go to main");
          }
          // & Phase 4. HomeScreen으로 이동
          if (!context.mounted) return;
          context.go('/home');
        } else {
          // credential이 null인 경우에 대한 처리
          debugPrint('Error: credential is null');
        }
      } on SignInWithAppleAuthorizationException catch (e) {
        // Apple 인증 중 발생한 예외 처리
        debugPrint('SignInWithAppleAuthorizationException: $e');
      } catch (e) {
        // 기타 예외 처리
        debugPrint('Error during Apple sign in: $e');
      }
    }

    return WillPopScope(
      onWillPop: (() async {
        final shouldExit = await _onWillPop(context);

        if (shouldExit) {
          SystemNavigator.pop(); // 앱을 종료합니다.
        }
        return false; // 두 번 눌러야 앱이 종료되도록 false 반환
      }),
      child: Scaffold(
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
              Column(
                children: [
                  // ! 구글 버튼
                  //버튼 클릭 효과 새로 지정
                  Container(
                    width: 327.w,
                    height: 54.h,
                    child: ElevatedButton(
                      onPressed: _signInWithGoogle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // 배경 색상
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r), // 모서리 둥글기
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/google_new.svg'),
                          SizedBox(width: 5.w),
                          Text(
                            'Google 계정으로 로그인',
                            style: FontSystem.Login16M.copyWith(
                                color: ColorSystem.googleFont),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // // ! 카카오 버튼
                  // Container(
                  //   width: 327.w,
                  //   height: 54.h,
                  //   child: ElevatedButton(
                  //     onPressed: _signInWithKaKao,
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: ColorSystem.kakao, // 배경 색상
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(6.r), // 모서리 둥글기
                  //       ),
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         SvgPicture.asset('assets/icons/kakao_new.svg'),
                  //         SizedBox(width: 5.w),
                  //         Text('카카오계정으로 로그인', style: FontSystem.Login16M),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  // ! 애플 버튼
                  // if (Platform.isIOS)
                  //   Container(
                  //     width: 327.w,
                  //     height: 54.h,
                  //     child: ElevatedButton(
                  //       onPressed: _signInWithApple,
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: ColorSystem.black, // 배경 색상
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(6.r), // 모서리 둥글기
                  //         ),
                  //       ),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           SvgPicture.asset('assets/icons/apple_new.svg'),
                  //           SizedBox(width: 5.w),
                  //           Text('Apple로 로그인',
                  //               style: FontSystem.Login16M.copyWith(
                  //                   color: ColorSystem.white)),
                  //         ],
                  //       ),
                  //     ),
                  //   ),

                  SizedBox(height: 10.h),
                  // ! 이메일 버튼
                  Container(
                    width: 327.w,
                    height: 54.h,
                    child: ElevatedButton(
                      onPressed: goBasicLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorSystem.black, // 배경 색상
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r), // 모서리 둥글기
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('이메일로 로그인',
                              style: FontSystem.Login16M.copyWith(
                                  color: ColorSystem.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50.h), // 버튼들 간의 간격 추가
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '아직 회원이 아니신가요?',
                        style: FontSystem.KR14R,
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      InkWell(
                        onTap: goSignUp,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            '회원가입',
                            style: FontSystem.KR14SB.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        '소셜로그인으로 진행 시,',
                        style: FontSystem.KR12R,
                      ),
                      InkWell(
                        onTap: () async {
                          final url = Uri.parse(
                              'https://www.notion.so/113b5a1edfe4804bb9aac7ff6d4bf34d'); // 이동할 URL을 입력
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url,
                                mode: LaunchMode.externalApplication);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Text('개인정보처리방침',
                              style: FontSystem.KR12B.copyWith(
                                decoration: TextDecoration.underline,
                              )),
                        ),
                      ),
                      Text(
                        '에 동의한 것으로 취급됩니다.',
                        style: FontSystem.KR12R,
                      )
                    ],
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

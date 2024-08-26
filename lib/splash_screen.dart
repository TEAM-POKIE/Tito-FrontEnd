import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/routes/routes.dart';
import 'package:tito_app/main.dart';
import 'package:tito_app/src/screen/login/login_main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart'; // 가로방향 막히기

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    requestPermissions(); // 카메라 및 사진 권한 요청

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // 3초 후에 API_ACCESS_TOKEN을 확인하고, 페이지를 이동
    Timer(Duration(seconds: 3), () async {
      await checkAccessTokenAndNavigate();
    });
  }

  Future<void> requestPermissions() async {
    // 카메라와 사진 권한 요청
    await [Permission.camera, Permission.photos].request();
  }

  Future<void> checkAccessTokenAndNavigate() async {
    // API_ACCESS_TOKEN을 읽어옵니다.
    final token = await secureStorage.read(key: 'API_ACCESS_TOKEN');

    // 상태를 업데이트합니다.
    refreshNotifier.value = !refreshNotifier.value;

    // 토큰이 있다면 /main으로, 없다면 /login으로 이동
    if (token != null && token.isNotEmpty) {
      if (rootNavigatorKey.currentContext != null) {
        print(token);

        // GoRouter.of(rootNavigatorKey.currentContext!).go('/home');
        GoRouter.of(rootNavigatorKey.currentContext!).go('/login');
      }
    } else {
      if (rootNavigatorKey.currentContext != null) {
        GoRouter.of(rootNavigatorKey.currentContext!).go('/login');
      } else {
        // 적절한 에러 처리 또는 디버깅 로그 추가
        print('Error: rootNavigatorKey.currentContext is null');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashIconSize: 162.w, // 크기를 screenutil로 조정
      duration: 3000,
      splash: Container(
        // 로고가 Container 안에 지정될 것이다
        width: 162.w, // 너비를 screenutil로 비율 조정
        height: 127.w,
        decoration: const BoxDecoration(
          color: ColorSystem.purple, // 배경색 설정 (보라색)
          image: DecorationImage(
            image: AssetImage('assets/images/splashs.png'),
            fit: BoxFit.fitWidth, // 이미지를 중앙에 고정하고 비율을 유지하며 맞춤
          ),
        ),
      ),
      nextScreen: const LoginMain(), // 실제로 이 화면은 사용되지 않음, 조건에 따라 이동
      splashTransition: SplashTransition.fadeTransition, // 스플래시 화면 전환 애니메이션 설정
      backgroundColor: ColorSystem.purple, // 배경색 설정
    );
  }
}

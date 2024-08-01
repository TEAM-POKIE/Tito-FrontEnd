import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/main.dart';
import 'package:tito_app/core/routes/routes.dart';
import 'package:tito_app/src/screen/login/login_main.dart';
// GlobalKey와 ValueNotifier를 사용하기 위해 main.dart 파일을 import
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    requestPermissions(); //카메라 및 사진권한 요청
    // 3초 후에 LoginMain 페이지로 이동
    Timer(Duration(seconds: 3), () {
      refreshNotifier.value = !refreshNotifier.value; // 상태 업데이트
      if (rootNavigatorKey.currentContext != null) {
        GoRouter.of(rootNavigatorKey.currentContext!)
            .go('/login'); // GlobalKey를 사용하여 페이지 전환
      } else {
        // 적절한 에러 처리 또는 디버깅 로그 추가
        print('Error: rootNavigatorKey.currentContext is null');
      }
    });
  }

  Future<void> requestPermissions() async {
    //카메라와 사진권한 요청
    await [Permission.camera, Permission.photos]
        .request(); //권한 요청 수행 및 완료될때까지 기다리기
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashIconSize: 162.w, // 크기를 screenutil로 조정
      duration: 3000,
      splash: Container(
        //로고가 Containter 안에 지정될 것이다
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
      nextScreen: const LoginMain(),
      splashTransition:
          SplashTransition.fadeTransition, // 스플래시 화면 전환 애니메이션 설정 (옵션)
      backgroundColor: ColorSystem.purple, // 배경색 설정 (옵션)
    );
  }
}

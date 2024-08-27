import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/routes/routes.dart';

import 'package:tito_app/src/screen/login/login_main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    requestPermissions();

    Timer(Duration(seconds: 3), () async {
      await checkAccessTokenAndNavigate();
    });
  }

  Future<void> requestPermissions() async {
    await [Permission.camera, Permission.photos].request();
  }

  Future<void> checkAccessTokenAndNavigate() async {
    final token = await secureStorage.read(key: 'API_ACCESS_TOKEN');

    refreshNotifier.value = !refreshNotifier.value;

    if (token != null && token.isNotEmpty) {
      if (rootNavigatorKey.currentContext != null) {
        print(token);

        // GoRouter.of(rootNavigatorKey.currentContext!).go('/home');
        GoRouter.of(rootNavigatorKey.currentContext!).go('/login');
      }
    } else {
      if (rootNavigatorKey.currentContext != null) {
        GoRouter.of(rootNavigatorKey.currentContext!).go('/login');

        print('Error: rootNavigatorKey.currentContext is null');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: AnimatedSplashScreen(
        splashIconSize: 162.w,
        duration: 3000,
        splash: Container(
          width: 162.w,
          height: 127.w,
          decoration: const BoxDecoration(
            color: ColorSystem.purple,
            image: DecorationImage(
              image: AssetImage('assets/images/splashs.png'),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        nextScreen: const LoginMain(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: ColorSystem.purple,
      ),
    );
  }
}

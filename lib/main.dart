import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routes/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';

import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter/services.dart'; // 가로방향 막히기

Future main() async {
  await dotenv.load(fileName: ".env");

  KakaoSdk.init(
    nativeAppKey: dotenv.env['OAUTH_KAKAO_NATIVE_APP_KEY'],
    javaScriptAppKey: dotenv.env['OAUTH_KAKAO_JAVASCRIPT_APP_KEY'],
  );

  // 세로 모드 고정
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const SafeArea(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // 피그마에 디자인 된 앱 프레임 사이즈로 맞춰서 적용한 것
      minTextAdapt: true, // 텍스트 크기를 자동으로 조정하여 화면에 맞추는 기능을 활성화
      splitScreenMode: true, // 분할 화면 모드를 활성화
      builder: (context, child) => ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
          title: 'Tito',
          theme: ThemeData(
            scaffoldBackgroundColor: ColorSystem.white,
            primaryColor: ColorSystem.purple,
          ),
        ),
      ),
    );
  }
}

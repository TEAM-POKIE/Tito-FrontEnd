import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routes/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';

void main() async {
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
            primaryColor: ColorSystem.purple,
          ),
        ),
      ),
    );
  }
}

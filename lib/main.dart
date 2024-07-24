import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routes/routes.dart';

void main() async {
  runApp(const SafeArea(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //ProviderScope는 Riverpod 패키지에서 제공하는 위젯으로, 애플리케이션 전체에서 프로바이더 사용가능하도록 함
    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
        title: 'Tito',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
      ),
    );
  }
}

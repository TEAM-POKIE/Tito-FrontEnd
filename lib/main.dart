import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routes/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const SafeArea(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) => ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
          title: 'Tito',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}

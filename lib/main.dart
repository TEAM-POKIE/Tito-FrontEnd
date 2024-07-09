import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/screen/login_screen.dart';
import 'package:tito_app/widgets/reuse/testscreen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MaterialApp(
        // home: Scaffold(
        //   body: LoginScreen(),
        // ),
        home: LoginScreen(),
      ),
    ),
  );
}
//현재 home을 Scaffold로 감싸니까 이상해서 그냥 LoginScreen()으로 바로 연결함

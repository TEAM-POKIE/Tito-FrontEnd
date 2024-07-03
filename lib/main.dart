import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/screen/login_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: LoginScreen(),
        ),
      ),
    ),
  );
}

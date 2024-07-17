import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/screen/home_screen.dart';

class MypageAppbar extends ConsumerWidget {
  const MypageAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          context.go('/home');
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(builder: (context) => const HomeScreen()),
          //   (Route<dynamic> route) => false,
          // );
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      title: const Text(
        '마이페이지',
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

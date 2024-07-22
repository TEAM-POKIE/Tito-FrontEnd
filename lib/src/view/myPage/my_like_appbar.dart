import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/screen/home_screen.dart';

class MyLikeAppbar extends StatelessWidget {
  const MyLikeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          context.go('/mypage');
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      title: const Text(
        '좋아요',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }
}

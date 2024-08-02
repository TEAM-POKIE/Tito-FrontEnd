import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/screen/home_screen.dart';
import 'package:tito_app/core/constants/style.dart';

class MyBlockAppbar extends StatelessWidget {
  const MyBlockAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorSystem.white,
      leading: IconButton(
        onPressed: () {
          context.go('/mypage');
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      title: const Text('차단 리스트', style: FontSystem.KR16B),
      centerTitle: true,
    );
  }
}

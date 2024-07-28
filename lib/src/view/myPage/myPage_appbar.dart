import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/src/screen/home_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MypageAppbar extends ConsumerWidget {
  const MypageAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          context.go('/home');
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      title: const Text(
        '마이페이지',
        style: FontSystem.KR16B
      ),
      centerTitle: true, // 타이틀 중앙 정렬
    );
  }
}
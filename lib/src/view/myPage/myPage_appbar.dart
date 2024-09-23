import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:tito_app/core/constants/style.dart';

class MypageAppbar extends ConsumerWidget {
  const MypageAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: ColorSystem.white,
      automaticallyImplyLeading: false,
      title: Text('마이페이지', style: FontSystem.KR16SB),
      centerTitle: true, // 타이틀 중앙 정렬
    );
  }
}

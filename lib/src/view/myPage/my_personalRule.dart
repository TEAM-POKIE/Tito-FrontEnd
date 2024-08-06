import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/constants/style.dart';


class MyPersonalrule extends StatelessWidget {
  const MyPersonalrule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSystem.white,
        leading: IconButton(
          onPressed: () {
            context.go('/mypage');
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: const Text('개인정보처리방침', style: FontSystem.KR16SB),
      ),
    );
  }
}

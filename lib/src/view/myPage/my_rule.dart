import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/constants/style.dart';


class MyRule extends StatelessWidget {
  const MyRule({super.key});

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
        title: Text('이용약관', style: FontSystem.KR16SB),
      ),
    );
  }
}
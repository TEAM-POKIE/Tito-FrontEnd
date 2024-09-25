import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_svg/svg.dart';

class MyPersonalrule extends StatelessWidget {
  const MyPersonalrule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: ColorSystem.white,
        leading: IconButton(
        onPressed: () {
          context.pop();
        },
        icon: SvgPicture.asset('assets/icons/back_arrow.svg'),
      ),
        centerTitle: true,
        title: Text('개인정보처리방침', style: FontSystem.KR16SB),
      ),
    );
  }
}

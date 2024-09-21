import 'package:flutter/material.dart';
import 'package:tito_app/core/constants/style.dart';

class MyAlarmAppbar extends StatelessWidget {
  const MyAlarmAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorSystem.white,
      title: Text(
        '알림',
        style: FontSystem.KR16SB,
      ),
      centerTitle: true,
    );
  }
}

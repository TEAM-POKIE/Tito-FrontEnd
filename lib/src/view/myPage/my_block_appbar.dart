import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_svg/svg.dart';

class MyBlockAppbar extends StatelessWidget {
  const MyBlockAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorSystem.white,
      leading: IconButton(
        onPressed: () {
          context.pop();
        },
        icon: SvgPicture.asset('assets/icons/back_arrow.svg'),
      ),
      title: Text('차단 리스트', style: FontSystem.KR16SB),
      centerTitle: true,
    );
  }
}

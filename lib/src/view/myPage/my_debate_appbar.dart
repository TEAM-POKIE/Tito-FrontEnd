import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_svg/svg.dart';

class MyDebateAppbar extends StatelessWidget {
  const MyDebateAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: ColorSystem.white,
      leading: IconButton(
        onPressed: () {
          context.pop();
        },
        icon: SvgPicture.asset('assets/icons/back_arrow.svg'),
      ),
      title: Text(
        '내가 참여한 토론',
        style: FontSystem.KR16SB,
      ),
      centerTitle: true,
    );
  }
}

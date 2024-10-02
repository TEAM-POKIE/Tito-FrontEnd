import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeAppbar extends ConsumerWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: AppBar(
        elevation: 0, // 스크롤 여부와 상관없이 elevation을 0으로 설정
        scrolledUnderElevation: 0, // 스크롤 시 그림자가 생기지 않도록 설정
        backgroundColor: Colors.transparent, // 필요하다면 AppBar를 투명하게 설정
        leading: Image.asset('assets/images/logo.png'),
        leadingWidth: 69.41.w,
        actions: [
          IconButton(
            onPressed: () {
              context.push('/search');
            },
            icon: SizedBox(
              child: SvgPicture.asset(
                'assets/icons/new_search.svg',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

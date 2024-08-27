import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:tito_app/core/provider/home_state_provider.dart';

class HomeAppbar extends ConsumerWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final homeViewModel = ref.read(homeViewModelProvider.notifier);
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: AppBar(
        backgroundColor: ColorSystem.white,
        leading: Image.asset('assets/images/logo.png'),
        leadingWidth: 69.41.w,
        actions: [
          IconButton(
            onPressed: () {
              context.push('/search');
            },
            icon: SizedBox(
              // width: 30.w,
              // height: 30.h,
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

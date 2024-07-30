import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/screen/home_screen.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

class MyAlarmScrollbody extends ConsumerWidget {
  const MyAlarmScrollbody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            '새로운 알림',
            style: FontSystem.KR20R,
          ),
        ),
        SizedBox(height: 30.h),
        Container(
          width: 350.w,
          height: 460.h,
          child: SingleChildScrollView(),
        ),
        SizedBox(height: 40.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            '지난 알림',
            style: FontSystem.KR20R,
          ),
        ),
        SizedBox(height: 30.h,),
        SingleChildScrollView(),
      ],
    );
  }
}

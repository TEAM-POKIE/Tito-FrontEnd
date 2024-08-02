import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tito_app/core/provider/home_state_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';

class HotFighter extends ConsumerWidget {
  const HotFighter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  const Text(
                    'HOT한 토론러',
                    style: FontSystem.KR18B,
                  ),
                  SizedBox(width: 4.w,),
                  Container(
                    width: 20.w,
                    height: 20.h,
                    child: Image.asset('assets/images/star.png')),
                ],
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            Container(
              //padding: EdgeInsets.symmetric(horizontal: 10.w),
              height: 150.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10, // 예시로 10개의 아이템
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30.w,
                          backgroundImage: AssetImage(
                              'assets/images/hot_fighter.png'), // 프로필 이미지 경로
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '일인자',
                          style: FontSystem.KR16R,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            //SizedBox(height:56.62.h ,),
          ],
        ),
      ),
    );
  }
}

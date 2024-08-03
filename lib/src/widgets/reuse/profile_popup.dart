import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePopup extends ConsumerWidget {
  const ProfilePopup({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      backgroundColor: ColorSystem.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        width: 350.w,
        height: 580.h,
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 10.h),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('프로필', style: FontSystem.KR14B),
                // IconButton(
                //   icon: Icon(Icons.close),
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                // ),
              ],
            ),
            SizedBox(height: 42.h),
            Row(
              children: [
                SvgPicture.asset('assets/icons/circle_profile.svg',
                width: 70.w,
                height: 70.h),
                SizedBox(width: 20.w),
              ],
            ),
            SizedBox(height: 41.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Divider(
                    color: ColorSystem.grey3,
                    thickness: 2,
                  ),
                  SizedBox(height: 20.h),
                  const Text(
                    '참여한 토론',
                    style: FontSystem.KR14B,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

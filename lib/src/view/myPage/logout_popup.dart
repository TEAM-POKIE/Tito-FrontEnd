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

class LogoutPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorSystem.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        width: 280.w,
        height: 300.h,
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  'assets/icons/popup_face.svg',
                  width: 40.w,
                  height: 40.h,
                ),
                // IconButton(
                //   icon: Icon(Icons.close),
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                // ),
              ],
            ),
            SizedBox(height: 16.h),
            const Text(
              '정말로 로그아웃 하시겠습니까?',
              style: FontSystem.KR18B,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            Container(
              width: 248.w,
              height: 109.h,
              decoration: BoxDecoration(
                color: ColorSystem.grey3,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 25.h),
                child: const Text(
                  '로그아웃 하시면\n추후 앱을 이용하실 때\n다시 로그인을 해야해요',
                  style: FontSystem.KR14R,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 25.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorSystem.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: () {
                  // Add your membership cancellation logic here
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 241.w,
                  height: 40.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 11.h),
                    child: Text(
                      '로그아웃 하기',
                      style:
                          FontSystem.KR14R.copyWith(color: ColorSystem.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

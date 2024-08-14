import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/provider/nav_provider.dart';
import 'package:tito_app/src/screen/login/login_main.dart';

class LogoutPopup extends ConsumerWidget {
  // ConsumerWidget으로 변경
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref 추가
    void putLogOut() async {
      await ApiService(DioClient.dio).postLogOut();
      await secureStorage.delete(key: 'API_ACCESS_TOKEN');
      await secureStorage.delete(key: 'API_REFRESH_TOKEN');
      final notifier = ref.read(selectedIndexProvider.notifier);
      notifier.state = 0;
      context.go('/login');
    }

    return Dialog(
      backgroundColor: ColorSystem.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        width: 280.w,
        height: 300.h,
        child: Column(
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
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              '정말로 로그아웃 하시겠습니까?',
              style: FontSystem.KR18SB,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            Container(
              width: 248.w,
              height: 100.h,
              decoration: BoxDecoration(
                color: ColorSystem.grey3,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 25.h),
                child: Text(
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
                  putLogOut();
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

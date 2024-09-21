import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';

import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ChangePassword extends ConsumerWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    InputTextFieldController _currentController = InputTextFieldController();
    InputTextFieldController _newPasswordController =
        InputTextFieldController();
    InputTextFieldController();
    void changePassWord() async {
      await ApiService(DioClient.dio).putPassword({
        "currentPassword": _currentController.text,
        "newPassword": _newPasswordController.text,
      });

      context.go('/mypage');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSystem.white,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: SvgPicture.asset('assets/icons/back_arrow.svg'),
        ),
        centerTitle: true,
        title: Text('비밀번호 변경', style: FontSystem.KR16SB),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 51.h),
            Text('현재 비밀번호', style: FontSystem.KR16SB),
            SizedBox(height: 10.h),
            TextField(
              controller: _currentController,
              decoration: InputDecoration(
                filled: true,
                fillColor: ColorSystem.ligthGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.r)),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: ColorSystem.black),
            ),
            SizedBox(height: 20.h),
            Text('새 비밀번호', style: FontSystem.KR16SB),
            SizedBox(height: 10.h),
            TextField(
              decoration: InputDecoration(
                hintText: '비밀번호 (영문,숫자 조합 8자 이상)',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: ColorSystem.ligthGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.r)),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: ColorSystem.black),
            ),
            SizedBox(height: 20.h),
            Text('새 비밀번호 재입력', style: FontSystem.KR16SB),
            SizedBox(height: 10.h),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                filled: true,
                fillColor: ColorSystem.ligthGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.r)),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: ColorSystem.black),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 47.h),
        child: SizedBox(
          width: 350.w,
          height: 60.h,
          child: ElevatedButton(
            onPressed: () {
              changePassWord();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorSystem.purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Text(
              '비밀번호 변경',
              style: TextStyle(fontSize: 20.sp, color: ColorSystem.white),
            ),
          ),
        ),
      ),
    );
  }
}

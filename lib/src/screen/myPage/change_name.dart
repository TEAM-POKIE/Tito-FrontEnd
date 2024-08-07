import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/src/widgets/reuse/purple_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/multpart_file_with_to_json.dart';

class ChangeName extends ConsumerWidget {
  const ChangeName({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    InputTextFieldController _titleController = InputTextFieldController();
    final loginInfo = ref.watch(loginInfoProvider);
    void changeNickName() async {
      final respons = await ApiService(DioClient.dio).putNickName({
        'nickname': _titleController.text,
      });
      final userInfoResponse = await ApiService(DioClient.dio).getUserInfo();

      final loginInfoNotifier = ref.read(loginInfoProvider.notifier);
      loginInfoNotifier.setLoginInfo(userInfoResponse);
      context.go('/mypage');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSystem.white,
        leading: IconButton(
          onPressed: () {
            context.go('/mypage');
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: const Text('닉네임 수정', style: FontSystem.KR16B),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 51.h),
            const Text('새로운 닉네임을 수정해주세요.', style: FontSystem.KR16SB),
            SizedBox(height: 20.h),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: '${loginInfo?.nickname}',
                hintStyle: TextStyle(color: ColorSystem.grey, fontSize: 16.sp),
                filled: true,
                fillColor: ColorSystem.grey3,
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
              changeNickName();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorSystem.purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Text(
              '완료',
              style: TextStyle(fontSize: 20.sp, color: ColorSystem.white),
            ),
          ),
        ),
      ),
    );
  }
}

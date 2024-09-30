import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChangeName extends ConsumerWidget {
  const ChangeName({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>(); // Form key 추가
    final _titleController = TextEditingController(); // 닉네임 입력 컨트롤러
    final loginInfo = ref.watch(loginInfoProvider);

    void changeNickName() async {
      if (_formKey.currentState!.validate()) {
        // 폼 유효성 검사
        await ApiService(DioClient.dio).putNickName({
          'nickname': _titleController.text,
        });

        final userInfoResponse = await ApiService(DioClient.dio).getUserInfo();
        final loginInfoNotifier = ref.read(loginInfoProvider.notifier);
        loginInfoNotifier.setLoginInfo(userInfoResponse);
        context.go('/mypage');
      }
    }

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: ColorSystem.white,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: SvgPicture.asset('assets/icons/back_arrow.svg'),
        ),
        centerTitle: true,
        title: Text('닉네임 수정', style: FontSystem.KR16SB),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          // Form으로 감싸기
          key: _formKey, // Form key 설정
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 51.h),
              Text('새로운 닉네임을 수정해주세요.', style: FontSystem.KR16SB),
              SizedBox(height: 20.h),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: '${loginInfo?.nickname}',
                  hintStyle:
                      TextStyle(color: ColorSystem.grey, fontSize: 16.sp),
                  filled: true,
                  fillColor: ColorSystem.grey3,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.r)),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: ColorSystem.black),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '닉네임을 입력해 주세요.';
                  }
                  if (value.length > 10) {
                    return '닉네임은 10글자 이하로 적어주세요.';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9가-힣]+$').hasMatch(value)) {
                    return '닉네임은 영문, 숫자, 한글만 사용할 수 있습니다.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 47.h),
        child: SizedBox(
          width: 350.w,
          height: 60.h,
          child: ElevatedButton(
            onPressed: () {
              changeNickName(); // 유효성 검사 후 닉네임 변경
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

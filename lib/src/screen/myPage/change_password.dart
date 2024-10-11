import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // 비밀번호 유효성 검사 (영문 + 숫자 포함, 8자 이상)
  bool _validateNewPassword(String password) {
    final passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return passwordRegExp.hasMatch(password);
  }

  Future<void> changePassWord() async {
    // 새 비밀번호 유효성 검사
    if (!_validateNewPassword(_newPasswordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("새 비밀번호는 영문, 숫자 조합 8자 이상이어야 합니다.")),
      );
      return;
    }

    // 새 비밀번호와 재입력 비밀번호가 일치하지 않을 때
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("새 비밀번호가 일치하지 않습니다.")),
      );
      return;
    }

    try {
      // 비밀번호 변경 요청
      await ApiService(DioClient.dio).putPassword({
        "currentPassword": _currentController.text,
        "newPassword": _newPasswordController.text,
      });
      // 성공적으로 변경되면 마이페이지로 이동
      context.go('/mypage');
    } catch (e) {
      // 서버에서 반환된 오류가 '현재 비밀번호가 틀렸을 때' 처리
      if (e.toString().contains("Incorrect current password")) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("현재 비밀번호가 틀렸습니다.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("현재 비밀번호가 틀렸습니다.")),
        );
      }
    }
  }

  @override
  void dispose() {
    _currentController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 키보드를 내리기 위해 화면을 터치할 때
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
          title: Text('비밀번호 변경', style: FontSystem.KR16SB),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 51.h),
                          Text('현재 비밀번호', style: FontSystem.KR16SB),
                          SizedBox(height: 10.h),
                          TextField(
                            controller: _currentController,
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: ColorSystem.ligthGrey,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.r)),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: const TextStyle(color: ColorSystem.black),
                          ),
                          SizedBox(height: 20.h),
                          Text('새 비밀번호', style: FontSystem.KR16SB),
                          SizedBox(height: 10.h),
                          TextField(
                            controller: _newPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: '비밀번호 (영문,숫자 조합 8자 이상)',
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: ColorSystem.ligthGrey,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.r)),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: const TextStyle(color: ColorSystem.black),
                          ),
                          SizedBox(height: 20.h),
                          Text('새 비밀번호 재입력', style: FontSystem.KR16SB),
                          SizedBox(height: 10.h),
                          TextField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: ColorSystem.ligthGrey,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.r)),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: const TextStyle(color: ColorSystem.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          height: 100.h,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: changePassWord,
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

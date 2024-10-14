import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<Signup> {
  var _email = '';
  var _nickname = '';
  var _password = '';
  final _formKey = GlobalKey<FormState>();
  final Uri perseonalUri = Uri.parse(
      'https://nine-grade-d65.notion.site/113b5a1edfe4804bb9aac7ff6d4bf34d?pvs=4');
  bool _obscureText = true;
  String? _emailError; // 이메일 에러 메시지
  String? _nicknameError; // 닉네임 에러 메시지
  bool _isChecked = false;
  bool _checkBoxError = false; // 체크박스 에러 상태

  void _onSignUp() async {
    final isValid = _formKey.currentState!.validate();
    _formKey.currentState!.save();

    // 체크박스 상태 확인
    if (!_isChecked) {
      setState(() {
        _checkBoxError = true; // 체크박스 에러 상태를 true로 설정
      });
      return;
    } else {
      setState(() {
        _checkBoxError = false; // 체크박스 에러 상태를 false로 설정
      });
    }

    if (isValid) {
      final signUpData = {
        'nickname': _nickname,
        'email': _email,
        'password': _password,
        'role': 'user',
      };

      final apiService = ApiService(DioClient.dio);

      try {
        await apiService.signUp(signUpData);
        context.pop();
      } catch (e) {
        if (e is DioError && e.response?.statusCode == 409) {
          final message = e.response?.data['message'] ?? '';
          setState(() {
            if (message.contains('닉네임')) {
              _nicknameError = message;
            } else if (message.contains('이메일')) {
              _emailError = message;
            }
          });
        } else {
          print('Failed to sign up: $e');
          // 다른 에러 처리
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: ColorSystem.white,
        leading: IconButton(
          onPressed: () {
            context.go('/login');
          },
          icon: SvgPicture.asset('assets/icons/back_arrow.svg'),
        ),
        title: Text('회원가입'),
        titleTextStyle: FontSystem.KR16SB,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey, // Form에 key 설정
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 105.h),
                Text('닉네임', style: FontSystem.KR20SB),
                SizedBox(height: 10.h),
                TextFormField(
                  maxLength: 10,
                  decoration: InputDecoration(
                    hintText: '닉네임을 입력해 주세요. (10글자 이하)',
                    hintStyle:
                        FontSystem.KR16M.copyWith(color: ColorSystem.grey),
                    errorText: _nicknameError,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '닉네임을 입력해 주세요.';
                    }
                    if (value.length > 10) {
                      return '닉네임은 10글자 이하로 적어주세요';
                    }
                    if (!RegExp(r'^[a-zA-Z0-9가-힣]+$').hasMatch(value)) {
                      return '닉네임은 영문, 숫자, 한글만 사용할 수 있습니다.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _nickname = value!;
                  },
                ),
                SizedBox(height: 30.h),
                Text('이메일', style: FontSystem.KR20SB),
                SizedBox(height: 10.h),
                TextFormField(
                  maxLength: 20,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: '이메일을 입력해주세요',
                    hintStyle:
                        FontSystem.KR16M.copyWith(color: ColorSystem.grey),
                    errorText: _emailError, // 이메일 에러 메시지 표시
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '이메일을 입력해주세요';
                    }
                    // 이메일 형식 유효성 검사
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return '올바른 이메일 형식을 입력해주세요';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
                SizedBox(height: 30.h),
                Text('비밀번호', style: FontSystem.KR20SB),
                SizedBox(height: 10.h),
                TextFormField(
                  maxLength: 20,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: '비밀번호 (영문, 숫자 조합 8자 이상)',
                    hintStyle:
                        FontSystem.KR16M.copyWith(color: ColorSystem.grey),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: _obscureText
                            ? ColorSystem.grey
                            : ColorSystem.purple,
                        size: 18.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '비밀번호를 입력해주세요';
                    }
                    // 비밀번호 최소 길이 및 문자 조합 유효성 검사 (영문, 숫자 포함, 특수문자는 선택)
                    if (value.length < 8 ||
                        !RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$')
                            .hasMatch(value)) {
                      return '비밀번호는 영문, 숫자 조합 8자 이상이어야 합니다.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        launchUrl(
                          perseonalUri,
                          mode: LaunchMode.inAppBrowserView,
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          '개인정보 처리방침',
                          style: FontSystem.KR12B.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '에 동의하시겠습니까?(필수)',
                      style: FontSystem.KR12B,
                    ),
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
                if (_checkBoxError)
                  Text(
                    '개인정보 처리방침에 동의하셔야 합니다.',
                    style: TextStyle(color: Colors.red, fontSize: 12.sp),
                  ),
                SizedBox(height: 60.h),
                Container(
                  width: 350.w,
                  height: 60.h,
                  child: ElevatedButton(
                    onPressed: _onSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: Text(
                      '회원가입',
                      style:
                          FontSystem.KR20SB.copyWith(color: ColorSystem.white),
                    ),
                  ),
                ),
                SizedBox(height: 44.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

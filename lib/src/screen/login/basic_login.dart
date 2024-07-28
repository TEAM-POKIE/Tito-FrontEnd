import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';

class BasicLogin extends ConsumerStatefulWidget {
  const BasicLogin({super.key});

  @override
  ConsumerState<BasicLogin> createState() {
    return _BasicLoginState();
  }
}

class _BasicLoginState extends ConsumerState<BasicLogin> {
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _onLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    try {
      // 로그인 요청
      final authResponse = await ApiService(DioClient.dio).signIn({
        'email': _enteredEmail,
        'password': _enteredPassword,
      });

      // 액세스 토큰 저장
      await DioClient.setToken(authResponse.accessToken.token);

      // 사용자 정보 요청
      final userInfoResponse = await ApiService(DioClient.dio).getUserInfo();

      // JSON 응답을 LoginInfo 객체로 변환
      final userInfo = userInfoResponse;

      // 로그인 정보를 상태로 저장
      ref.read(loginInfoProvider.notifier).state = userInfo;

      // HomeScreen으로 이동
      if (context.mounted) {
        context.go('/home');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurred: $error'),
        ),
      );
    }
  }

  void _goSignUp() {
    context.push('/signup'); // Signup 화면으로 이동
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.go('/login');
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('로그인'),
        titleTextStyle: FontSystem.KR16R,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 105.h,
                ),
                const Text(
                  '이메일',
                  style: FontSystem.KR20B,
                ),
                SizedBox(
                  height: 12.h,
                ),
                TextFormField(
                  maxLength: 50,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: '로그인 시 사용됩니다',
                    hintStyle: TextStyle(
                      color: ColorSystem.grey,
                      fontSize: 16,
                    ),
                    //hintStyle:
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '이메일을 입력해주세요';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredEmail = value!;
                  },
                ),
                SizedBox(
                  height: 50.h,
                ),
                const Text(
                  '비밀번호',
                  style: FontSystem.KR20B,
                ),
                TextFormField(
                  maxLength: 20,
                  decoration: const InputDecoration(
                    hintText: '비밀번호 (영문, 숫자 조합 8자 이상)',
                    hintStyle: TextStyle(
                      color: ColorSystem.grey,
                      fontSize: 16,
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '비밀번호를 입력해주세요';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredPassword = value!;
                  },
                ),
                SizedBox(
                  height: 50.h,
                ),
                Container(
                  width: 350.w,
                  height: 60.h,
                  child: ElevatedButton(
                    onPressed: _onLogin,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      backgroundColor: ColorSystem.black,
                      // padding:
                      //     EdgeInsets.symmetric(horizontal: 149.w, vertical: 20.h),
                    ),
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                          fontSize: 16,
                          color: ColorSystem.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    TextButton(
                      onPressed: _goSignUp,
                      child: const Text(
                        '회원가입',
                        style: TextStyle(
                          color: ColorSystem.purple,
                        ),
                      ),
                    ),
                    const Text('|'),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        '비밀번호 찾기',
                        style: TextStyle(
                          color: ColorSystem.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 200.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

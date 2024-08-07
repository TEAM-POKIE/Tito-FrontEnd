import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

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
  bool _obscureText = true;

  void _onLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    try {
      // & Phase 1. 백엔드에 로그인 요청
      final authResponse = await ApiService(DioClient.dio).signIn({
        'email': _enteredEmail,
        'password': _enteredPassword,
      });

      // & Phase 2. 수신한 Access, Refresh Token 시큐어 스토리지에 저장
      await DioClient.setToken(authResponse.accessToken.token);
      await secureStorage.write(
          key: 'API_ACCESS_TOKEN', value: authResponse.accessToken.token);
      await secureStorage.write(
          key: 'API_REFRESH_TOKEN', value: authResponse.refreshToken.token);

      // & Phase 3. 해당 토큰으로 사용자 Detail Data 요청
      final userInfoResponse = await ApiService(DioClient.dio).getUserInfo();
      final userInfo = userInfoResponse;

      final loginInfoNotifier = ref.read(loginInfoProvider.notifier);
      loginInfoNotifier.setLoginInfo(userInfo);

      // & Phase 4. HomeScreen으로 이동
      if (!context.mounted) return;
      context.go('/home');
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
        backgroundColor: ColorSystem.white,
        leading: IconButton(
          onPressed: () {
            context.go('/login');
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('로그인'),
        titleTextStyle: FontSystem.KR16SB,
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
                  height: 110.h,
                ),
                const Text(
                  '이메일',
                  style: FontSystem.KR20SB,
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextFormField(
                  //maxLength: 50,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  style: FontSystem.KR16M,
                  // TextStyle(
                  //   color: _enteredEmail.isNotEmpty
                  //       ? ColorSystem.purple
                  //       : ColorSystem.black,
                  //   fontSize: 16,
                  // ),
                  decoration: InputDecoration(
                    hintText: '로그인 시 사용됩니다',
                    hintStyle:
                        FontSystem.KR16M.copyWith(color: ColorSystem.grey),
                    // TextStyle(
                    //   color: _enteredEmail.isNotEmpty
                    //       ? ColorSystem.purple
                    //       : ColorSystem.grey,
                    //   fontSize: 16,
                    // ),
                    // focusColor: ColorSystem.purple,
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
                  style: FontSystem.KR20SB,
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextFormField(
                  //maxLength: 20,
                  obscureText: _obscureText, // 비밀번호 입력처럼 텍스트를 숨길지 여부
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
                    return null;
                  },
                  onSaved: (value) {
                    _enteredPassword = value!;
                  },
                ),
                SizedBox(
                  height: 167.h,
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
                    child: Text(
                      '로그인',
                      style:
                          FontSystem.KR20SB.copyWith(color: ColorSystem.white),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _goSignUp,
                      child: Text(
                        '회원가입',
                        style: FontSystem.KR14M
                            .copyWith(color: ColorSystem.purple),
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

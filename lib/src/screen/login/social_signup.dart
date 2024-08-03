import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';

class SocialSignup extends StatefulWidget {
  const SocialSignup({super.key});

  @override
  State<SocialSignup> createState() {
    return _SocialSignUpState();
  }
}

class _SocialSignUpState extends State<SocialSignup> {
  var _nickname = '';
  final _formKey = GlobalKey<FormState>();

  void _onSignUp() async {
    final isVaild = _formKey.currentState!.validate();
    _formKey.currentState!.save();
    if (isVaild) {
      final signUpData = {
        'nickname': _nickname,
        'role': 'user',
      };

      final apiService = ApiService(DioClient.dio);

      try {
        await apiService.signUp(signUpData);
        context.pop();
      } catch (e) {
        print('Failed to sign up: $e');
        // Handle error here, e.g., show a message to the user
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSystem.white,
        leading: IconButton(
          onPressed: () {
            context.go('/home');
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('회원가입'),
        titleTextStyle: FontSystem.KR16R,
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
                SizedBox(
                  height: 105.h,
                ),
                const Text(
                  '닉네임',
                  style: FontSystem.KR20B,
                ),
                SizedBox(
                  height: 12.h,
                ),
                TextFormField(
                  maxLength: 10,
                  decoration: const InputDecoration(
                    hintText: '닉네임을 입력해주세요',
                    hintStyle: TextStyle(
                      color: ColorSystem.grey,
                      fontSize: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '닉네임을 입력해주세요.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _nickname = value!;
                  },
                ),
                
                SizedBox(
                  height: 50.h,
                ),
                Container(
                  width: 350.w,
                  height: 60.h,
                  child: ElevatedButton(
                    onPressed: _onSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorSystem.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: const Text(
                      '시작하기',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 44.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

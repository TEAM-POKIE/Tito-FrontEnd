import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';

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

  void _onSignUp() async {
    final isVaild = _formKey.currentState!.validate();
    _formKey.currentState!.save();
    if (isVaild) {
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
        print('Failed to sign up: $e');
        // Handle error here, e.g., show a message to the user
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
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
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  '이메일',
                  style: FontSystem.KR20B,
                ),
                TextFormField(
                  maxLength: 50,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: '이메일을 입력해주세요',
                    hintStyle: TextStyle(
                      color: ColorSystem.grey,
                      fontSize: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '이메일을 입력해주세요';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text ('비밀번호', 
                style: FontSystem.KR20B,),
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
                    _password = value!;
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
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: const Text(
                      '회원가입',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 44.h,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

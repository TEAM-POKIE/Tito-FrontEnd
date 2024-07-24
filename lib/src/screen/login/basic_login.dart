import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';

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
        title: const Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: const InputDecoration(
                  label: Text('이메일'),
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
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                maxLength: 20,
                decoration: const InputDecoration(
                  label: Text('비밀번호'),
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
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                onPressed: _onLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(300, 60),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text(
                  '로그인',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _goSignUp,
                    child: const Text(
                      '이메일로 가입',
                      style: TextStyle(
                          color: Color(0xff8E48F8),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Text('|'),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      '비밀번호 찾기',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

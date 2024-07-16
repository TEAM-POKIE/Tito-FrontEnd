import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
// import 'package:tito_app/src/widgets/reuse/notification.dart';

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
    final url = Uri.https(
        'pokeeserver-default-rtdb.firebaseio.com', 'login_id_list.json');

    if (isVaild) {
      // initState에서 실행하던 초기화 코드
      // FlutterLocalNotification.init();
      // await Future.delayed(const Duration(seconds: 1),
      //     FlutterLocalNotification.requestNotificationPermission());

      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'nickname': _nickname,
            'email': _email,
            'password': _password,
          }));

      if (!context.mounted) {
        return;
      }

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey, // Form에 key 설정
          child: Column(
            children: [
              TextFormField(
                maxLength: 10,
                decoration: const InputDecoration(
                  label: Text('닉네임'),
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
                  _email = value!;
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
                  _password = value!;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                onPressed: _onSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(300, 60),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10), // 버튼 내부의 패딩 설정
                ),
                child: const Text(
                  '회원가입',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

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
        'tito-f8791-default-rtdb.firebaseio.com', 'login_id_list.json');
    if (isVaild) {
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
      Navigator.of(context).pop(widget);
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
                  // 이메일 형식 확인
                  // final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                  // if (!emailRegex.hasMatch(value)) {
                  //   return '유효한 이메일 주소를 입력해주세요';
                  // }
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
                  // if (value.length < 8) {
                  //   return '비밀번호는 8자 이상이어야 합니다';
                  // }
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
                  // 텍스트 스타일 설정
                ),
                child: const Text(
                  '회원가입',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     TextButton(
              //       onPressed: () {},
              //       child: const Text(
              //         '이메일로 가입',
              //         style: TextStyle(
              //             color: Color(0xff8E48F8),
              //             fontWeight: FontWeight.bold),
              //       ),
              //     ),
              //     const Text('|'),
              //     TextButton(
              //       onPressed: () {},
              //       child: const Text(
              //         '비밀번호 찾기',
              //         style: TextStyle(
              //             color: Colors.black, fontWeight: FontWeight.bold),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

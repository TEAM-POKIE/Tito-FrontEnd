import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/models/login_info.dart';
import 'package:tito_app/provider/login_provider.dart';
import 'package:tito_app/screen/home_screen.dart';
import 'package:tito_app/widgets/login/signup.dart';
import 'package:http/http.dart' as http;

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
      final url = Uri.https(
          'pokeeserver-default-rtdb.firebaseio.com', 'login_id_list.json');
      final response = await http.get(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to load data');
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      final List<LoginInfo> _loginItems = [];
      for (final item in listData.entries) {
        _loginItems.add(
          LoginInfo(
              id: item.key,
              nickname: item.value['nickname'],
              email: item.value['email'],
              password: item.value['password']),
        );
      }

      LoginInfo? loggedInUser;
      for (final loginItem in _loginItems) {
        if (loginItem.email == _enteredEmail &&
            loginItem.password == _enteredPassword) {
          loggedInUser = loginItem;
          break;
        }
      }

      if (loggedInUser != null) {
        ref.read(loginInfoProvider.notifier).state = loggedInUser;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('아이디 비밀번호를 제대로 입력해주세요'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurred: $error'),
        ),
      );
    }
  }

  void _goSignuUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Signup()),
    );
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
          key: _formKey, // Form에 key 설정
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10), // 버튼 내부의 패딩 설정
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
                    onPressed: _goSignuUp,
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

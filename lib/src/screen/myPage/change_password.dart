import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/src/widgets/reuse/purple_button.dart';


class ChangePassword extends ConsumerWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginInfo = ref.watch(loginInfoProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.go('/mypage');
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: const Text(
          '비밀번호 변경',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            const Text('현재 비밀번호',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0),
            const TextField(
              //controller: _titleController,
              decoration: InputDecoration(
                //hintText: '${loginInfo?.nickname}',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Color(0xFFF6F6F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20.0),
            const Text('새 비밀번호',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0),
            const TextField(
              //controller: _titleController,
              decoration: InputDecoration(
                hintText: '비밀번호 (영문,숫자 조합 8자 이상)',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Color(0xFFF6F6F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20.0),
            const Text('새 비밀번호 재입력',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0),
            const TextField(
              //controller: _titleController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFF6F6F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.black),
            ),
            const Spacer(), // 빈 공간을 채우는 Spacer
            Container(
              width: 350,
              height: 60,
              child: PurpleButton(
                text: '비밀번호 변경',
                onPressed: () {
                  context.go('/mypage');
                },
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/src/widgets/reuse/purple_button.dart';

class MyContact extends ConsumerWidget {
  const MyContact({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.go('/mypage');
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          '문의하기',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            const Text(
              '내용',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              height: 200.0,
              child: TextField(
                //controller: _contentController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 250.0),
                  // hintText: '입력하세요',
                  // hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFFF6F6F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: 125,
              height: 45,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E48F8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 16,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      '파일 첨부',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            const SizedBox(height: 30.0),
            const Text('연락받을 이메일',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0),
            const TextField(
              //controller: _titleController,
              decoration: InputDecoration(
                // hintText: '입력하세요',
                // hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Color(0xFFF6F6F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 30.0),
            const Text('이용자 아이디',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            const TextField(
              //controller: _titleController,
              decoration: InputDecoration(
                // hintText: '입력하세요',
                // hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Color(0xFFF6F6F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 30.0),
            const Text('학교',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            const TextField(
              //controller: _titleController,
              decoration: InputDecoration(
                // hintText: '입력하세요',
                // hintStyle: TextStyle(color: Colors.grey),
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
                text: '문의 접수',
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

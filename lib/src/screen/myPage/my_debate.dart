import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MyDebate extends ConsumerStatefulWidget {
  const MyDebate({super.key});

  @override
  ConsumerState<MyDebate> createState() {
    return _MyDebateState();
  }
}


class _MyDebateState extends ConsumerState<MyDebate> {
  final List<String> sortOptions = ['최신순', '인기순'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.go('/mypage');
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          '내가 참여한 토론',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                '포키님은 12번의 토론 중\n10번을 이기셨어요!',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
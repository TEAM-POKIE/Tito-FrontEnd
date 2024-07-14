import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebateCollect extends ConsumerStatefulWidget {
  const DebateCollect({super.key});

  @override
  ConsumerState<DebateCollect> createState() {
    return _DebateCollectState();
  }
}


class _DebateCollectState extends ConsumerState<DebateCollect> {
  final List<String> sortOptions = ['최신순', '인기순'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          '내가 참여한 토론',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text(
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

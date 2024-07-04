import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/provider/login_provider.dart';

class Mypage extends ConsumerWidget {
  const Mypage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginInfo = ref.watch(loginInfoProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('마이페이지렁이빨빠지면아파요hello'),
      ),
      body: Text(
        '${loginInfo?.nickname}',
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/provider/login_provider.dart';

class MyAlarm extends ConsumerWidget {
  const MyAlarm({super.key});

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
          '알림',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30.0),
            Stack(
              children: [],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tito_app/widgets/reuse/bottombar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0), // AppBar 높이를 조정
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/logo.png', // 로고 이미지 경로
              fit: BoxFit.contain,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Image.asset('assets/images/notification.png'),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset('assets/images/mypage.png'),
            ),
          ],
        ),
      ),
      body: const BottomBar(),
    );
  }
}

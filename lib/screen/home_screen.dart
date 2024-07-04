import 'package:flutter/material.dart';
import 'package:tito_app/widgets/mypage/mypage.dart';
import 'package:tito_app/widgets/reuse/bottombar.dart';
//import 'package:tito_app/widgets/reuse/searchBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

void _goMyPage(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (ctx) => const Mypage(),
    ),
  );
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
              onPressed: () {
                _goMyPage(context);
              },
              icon: Image.asset('assets/images/mypage.png'),
            ),
          ],
        ),
      ),      
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: SearchBar(
              leading: Icon(Icons.search),
              hintText: '토론 검색어를 입력하세요',
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context,index) {
                return ListTile(
                  title: Text('Item $index'),
                );
              },
            ),
          ),
          const BottomBar()
        ],
      ),
    );
  }
}
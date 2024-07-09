import 'package:flutter/material.dart';
import 'package:tito_app/widgets/reuse/bottombar.dart';
import 'package:tito_app/widgets/reuse/testscreen.dart';
import 'package:tito_app/models/free_list_data.dart';
import 'package:tito_app/widgets/reuse/search_bar.dart';

class FreeScreen extends StatefulWidget {
  const FreeScreen({super.key});

  @override
  _FreeScreenState createState() => _FreeScreenState();
}

class _FreeScreenState extends State<FreeScreen> {
  String result = '';
  bool isMetric = true;
  bool isImperial = false;
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = [isMetric, isImperial];
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text(
  //         '자유게시판',
  //         style: TextStyle(
  //           fontSize: 18,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     ),
  //     body: Column(
  //       children: [
  //         const SearchBar(),
  //         Expanded(
  //           child: ListView.separated(
  //             itemCount: posts.length,
  //             separatorBuilder: (BuildContext context, int index) => Divider(),
  //             itemBuilder: (BuildContext context, int index) {
  //               Post post = posts[index];

  //               return Container(
  //                 padding: EdgeInsets.all(16),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       post.title,
  //                       style: TextStyle(
  //                           fontSize: 18, fontWeight: FontWeight.bold),
  //                     ),
  //                     SizedBox(height: 10.0),
  //                     Row(
  //                       children: [
  //                         CircleAvatar(
  //                           backgroundImage: AssetImage(
  //                             'assets/images/user.png',
  //                           ), // 사용자 이미지
  //                         ),
  //                         SizedBox(width: 10.0),
  //                         Text(post.username, style: TextStyle(fontSize: 14)),
  //                         Spacer(),
  //                         Text(post.timeAgo,
  //                             style:
  //                                 TextStyle(fontSize: 12, color: Colors.grey)),
  //                       ],
  //                     ),
  //                     SizedBox(height: 12.0),
  //                     // 게시물 내용
  //                     Text(
  //                       post.content,
  //                       style: TextStyle(fontSize: 16),
  //                     ),
  //                     SizedBox(height: 8.0),
  //                     // 투표 버튼
  //                     // ElevatedButton(
  //                     //   onPressed: () {},
  //                     //   style: ElevatedButton.styleFrom(
  //                     //     primary: Colors.purple,
  //                     //   ),
  //                     // ),
  //                     // child: Text('투표  10명 투표 참여'),
  //                     // ),
  //                     SizedBox(height: 8.0),
  //                     // 좋아요, 조회수, 댓글 수]
  //                     Row(
  //                       children: [
  //                         Text(
  //                           '좋아요 ${post.likes}',
  //                           style: TextStyle(fontSize: 12, color: Colors.grey),
  //                         ),
  //                         SizedBox(width: 30),
  //                         Text(
  //                           '조회수 ${post.views}',
  //                           style: TextStyle(fontSize: 12, color: Colors.grey),
  //                         ),
  //                         SizedBox(width: 30),
  //                         Text(
  //                           '댓글 ${post.comments}',
  //                           style: TextStyle(fontSize: 12, color: Colors.grey),
  //                         ),
  //                       ],
  //                     ),
  //                     ToggleButtons(
  //                       children: [
  //                         Padding(
  //                           padding: EdgeInsets.symmetric(horizontal: 16),
  //                           child: Text(
  //                             '좋아요',
  //                             style: TextStyle(fontSize: 14),
  //                           ),
  //                         ),
  //                         Padding(
  //                           padding: EdgeInsets.symmetric(
  //                             horizontal: 16,
  //                           ),
  //                           child: Text(
  //                             '댓글 달기',
  //                             style: TextStyle(fontSize: 14),
  //                           ),
  //                         )
  //                       ],
  //                       isSelected: isSelected,
  //                       onPressed: toggleSelect,
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //     bottomNavigationBar: const BottomBar(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '자유게시판',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          //CustomSearchBar(),
          ListView(
            children: [
              CustomSearchBar(),
              // 검색창
              Padding(
                padding: EdgeInsets.all(30.0),
                //child: CustomSearchBar(),
              ),
              // 게시물 카드
              PostCard(),
              PostCard(),
              // 아래 ElevatedButton은 삭제됨
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF111111),
                  foregroundColor: const Color(0xFFDCF333)),
              icon: Icon(Icons.edit, size: 16),
              label: Text('글쓰기'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }

  void toggleSelect(value) {
    if (value == 0) {
      isMetric = true;
      isImperial = false;
    } else {
      isMetric = false;
      isImperial = true;
    }
    setState(() {
      isSelected = [isMetric, isImperial];
    });
  }
}

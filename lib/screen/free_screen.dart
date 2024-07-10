//######ListView ver######
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tito_app/screen/free_screen_detail.dart';
import 'package:tito_app/screen/free_screen_write.dart';
import 'package:tito_app/widgets/reuse/search_bar.dart';
import 'package:tito_app/widgets/reuse/bottombar.dart';

class FreeScreen extends StatelessWidget {
  final List<String> posts = List.generate(20, (index) => "Post $index");

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
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomSearchBar(),
              ),
              const SizedBox(height: 8.0),
              Container(
                height: 1.0,
                color: Colors.grey[300],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: const Row(
                        children: [
                          Text(
                            '애인의 우정 여행 어떻게 생각해??',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            '1분 전',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15.0,
                          ),
                          const Row(
                            children: [
                              SizedBox(
                                width: 3.0,
                              ),
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/usericon.png'),
                                radius: 13.0,
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text('타카'),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          const Text(
                              '연애중에 고민이 생겼어\n사귄지 1년 정도 됐는데 애인이 우정 여행을 간다는데'),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('투표'),
                              ),
                              SizedBox(width: 8.0),
                              Text('10명 투표 참여'),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '좋아요 12     조회수 32     댓글 9',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15.0),
                          Container(
                            height: 1.0,
                            color: Colors.grey[300],
                          ),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly, //가로축을 균등하게 하는 것
                            children: [
                              TextButton.icon(
                                onPressed: () {},
                                icon: Image.asset('assets/images/like_btn.png',
                                    width: 18),
                                label: const Text(
                                  '좋아요',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Container(
                                height: 24.0,
                                width: 1.0,
                                color: Colors.grey,
                              ),
                              TextButton.icon(
                                onPressed: () {},
                                icon: Image.asset(
                                    'assets/images/comment_btn.png',
                                    width: 18),
                                label: const Text(
                                  '댓글 달기',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 1.0,
                            color: Colors.grey[300],
                          ),
                          SizedBox(height: 10.0),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FreeScreenDetail(post: posts[index]),
                            ));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 13,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FreeScreenWrite(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF111111),
                  foregroundColor: const Color(0xFFDCF333)),
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('글쓰기'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}


//#######Card Ver######
// import 'package:flutter/material.dart';
// import 'package:tito_app/widgets/reuse/bottombar.dart';
// import 'package:tito_app/widgets/reuse/testscreen.dart';
// import 'package:tito_app/models/free_list_data.dart';
// import 'package:tito_app/widgets/reuse/search_bar.dart';

// class FreeScreen extends StatefulWidget {
//   const FreeScreen({super.key});

//   @override
//   _FreeScreenState createState() => _FreeScreenState();
// }

// class _FreeScreenState extends State<FreeScreen> {
//   String result = '';
//   bool isMetric = true;
//   bool isImperial = false;
//   late List<bool> isSelected;

//   @override
//   void initState() {
//     super.initState();
//     isSelected = [isMetric, isImperial];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           '자유게시판',
//           style: TextStyle(
//             fontSize: 19,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           //CustomSearchBar(),
//           ListView(
//             children: [
//               CustomSearchBar(),
//               // 검색창
//               Padding(
//                 padding: EdgeInsets.all(30.0),
//               ),
//               // 게시물 카드
//               PostCard(),
//               PostCard(),
//               // 아래 ElevatedButton은 삭제됨
//             ],
//           ),
//           Positioned(
//             bottom: 20,
//             right: 20,
//             child: ElevatedButton.icon(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF111111),
//                   foregroundColor: const Color(0xFFDCF333)),
//               icon: Icon(Icons.edit, size: 16),
//               label: Text('글쓰기'),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: const BottomBar(),
//     );
//   }

//   void toggleSelect(value) {
//     if (value == 0) {
//       isMetric = true;
//       isImperial = false;
//     } else {
//       isMetric = false;
//       isImperial = true;
//     }
//     setState(() {
//       isSelected = [isMetric, isImperial];
//     });
//   }
// }


import 'package:flutter/material.dart';

class Post {
  final String username;
  final String avatarUrl;
  final String timeAgo;
  final String title;
  final String content;
  final int likes;
  final int views;
  final int comments;

  Post({
    required this.username,
    required this.avatarUrl,
    required this.timeAgo,
    required this.title,
    required this.content,
    required this.likes,
    required this.views,
    required this.comments,
  });
}


// List<Post> posts = [
//   Post(
//     username: '타카',
//     avatarUrl: 'assets/images/usericon.png',
//     timeAgo: '1분 전',
//     title: '애인의 우정 여행 어떻게 생각해??',
//     content: '연애중에 고민이 생겼어 사귄지 1년 정도 됐는데 애인이 우정 여행을 간다는데',
//     likes: 12,
//     views: 32,
//     comments: 9,
//   ),

//   Post(username: '티키', avatarUrl: 'https://via.placeholder.com/150', timeAgo: '10분 전', title: '우가우가 오랑우탄 메롱롱롱', content: '동물원 가고 싶다. 안 가본지 오래됬는데', likes: 2, views: 40, comments: 4),
// ];


//#####이 부분이 Card로 만든 부분#####
class PostCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text(
              '애인의 우정 여행 어떻게 생각해??',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Spacer(),
                Text('1분 전',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            // 게시물 제목
            const SizedBox(height: 20.0),
            // 사용자 정보와 게시물 시간
            const Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/usericon.png'),
                      radius: 13.0,
                ),
                SizedBox(width: 15.0),
                Text('타카', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 25.0),
            // 게시물 내용
            const Text(
              '연애중에 고민이 생겼어\n사귄지 1년 정도 됐는데 애인이 우정 여행을 간다는데',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            // 투표 버튼
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(),
              child: Text('투표  10명 투표 참여'),
            ),
            const SizedBox(height: 8.0),
            // 좋아요, 조회수, 댓글 수
            const Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('좋아요 12',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(width: 18.0),
                Text('조회수 32',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(width: 18.0),
                Text('댓글 9',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


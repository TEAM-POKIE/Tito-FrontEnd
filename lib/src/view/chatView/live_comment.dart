import 'package:flutter/material.dart';

class LiveComments extends StatelessWidget {
  LiveComments({Key? key}) : super(key: key);

  // 더미 데이터 생성
  final List<Comment> comments = [
    Comment(
      username: '타카',
      message: '그건 아니지',
      profileImageUrl: 'https://via.placeholder.com/150',
      isLiked: false,
    ),
    Comment(
      username: 'dlkfj',
      message: '과학적으로 그렇긴 함',
      profileImageUrl: 'https://via.placeholder.com/150',
      isLiked: true,
    ),
    Comment(
      username: '뚜미둡',
      message: '포키님은 진짜 논리적이시네요',
      profileImageUrl: 'https://via.placeholder.com/150',
      isLiked: false,
    ),
    Comment(
      username: 'fdjkkjflds',
      message: '저 말이 맞는듯ㅋㅋ',
      profileImageUrl: 'https://via.placeholder.com/150',
      isLiked: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${comments.length}명 관전중',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(comment.profileImageUrl),
                  ),
                  title: Text(comment.username),
                  subtitle: Text(comment.message),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: comment.isLiked ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      // Like 버튼을 눌렀을 때의 로직을 추가하세요.
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Comment {
  final String username;
  final String message;
  final String profileImageUrl;
  final bool isLiked;

  Comment({
    required this.username,
    required this.message,
    required this.profileImageUrl,
    this.isLiked = false,
  });
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Live Comments'),
      ),
      body: LiveComments(),
    ),
  ));
}

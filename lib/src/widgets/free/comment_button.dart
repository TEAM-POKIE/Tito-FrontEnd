import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CommentButton extends StatefulWidget {
  @override
  _CommentButtonState createState() => _CommentButtonState();
}

class _CommentButtonState extends State<CommentButton> {
  final TextEditingController _controller = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _postComment(String postId, String comment) async {
  final url = Uri.https(
      'pokeeserver-default-rtdb.firebaseio.com', 'posts/$postId/comments.json');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'text': comment, 'timestamp': DateTime.now().toIso8601String()}),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to post comment');
  }
}

  Future<void> _submitComment() async {
    setState(() {
      _isSubmitting = true;
    });
    try {
      await _postComment('postId', _controller.text); // postId는 실제 포스트의 ID로 대체해야 합니다.
      _controller.clear();
    } catch (e) {
      // 에러 처리
      print('Error posting comment: $e');
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: '댓글을 입력하세요',
          ),
        ),
        TextButton.icon(
          onPressed: _isSubmitting ? null : _submitComment,
          icon: Image.asset('assets/images/comment_btn.png', width: 18),
          label: const Text(
            '댓글 달기',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: TextButton.icon(
//         onPressed: () {},
//         icon: Image.asset('assets/images/comment_btn.png', width: 18),
//         label: const Text(
//           '댓글 달기',
//           style: TextStyle(color: Colors.grey),
//         ),
//       ),
//     );
//   }
// }

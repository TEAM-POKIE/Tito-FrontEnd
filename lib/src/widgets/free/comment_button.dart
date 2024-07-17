import 'package:flutter/material.dart';

class CommentButton extends StatefulWidget {
  const CommentButton({super.key});

  @override
  _CommentButtonState createState() => _CommentButtonState();
}

class _CommentButtonState extends State<CommentButton> {
  final TextEditingController _controller = TextEditingController();
  final bool _isSubmitting = false;

  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: '댓글을 입력하세요',
          ),
        ),
        TextButton.icon(
          onPressed: () {},
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
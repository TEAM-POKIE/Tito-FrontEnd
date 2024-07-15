import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/provider/live_comment.dart';

class LiveSendView extends ConsumerWidget {
  final String username;

  const LiveSendView({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveCommentViewModel = ref.read(liveCommentProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: liveCommentViewModel.controller,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: '상대 의견 작성 타임이에요!',
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) {
                liveCommentViewModel.sendMessage(value);
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              liveCommentViewModel.sendMessage(username);
            },
            icon: Image.asset('assets/images/sendArrow.png'),
          ),
        ],
      ),
    );
  }
}

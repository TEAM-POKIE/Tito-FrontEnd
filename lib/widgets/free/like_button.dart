import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tito_app/provider/app_state.dart';

class LikeButton extends StatefulWidget {
  final String postId;

  LikeButton({required this.postId});

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  //int _likeCount = 0;
  bool _isLiked = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchLikeCount();
  // }

  // Future<void> _fetchLikeCount() async {
  //   final url =
  //       Uri.https('pokeeserver-default-rtdb.firebaseio.com', 'likes.json');
  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     // setState(() {
  //     //   _likeCount = json.decode(response.body) ?? 0;
  //     // });
  //     int fetchedCount = json.decode(response.body) ?? 0;
  //     Provider.of<AppState>(context, listen: false).setLikeCount(fetchedCount);
  //   }
  // }

  Future<void> _updateLikeCount(String postId, int newCount) async {
    final url = Uri.https(
        'pokeeserver-default-rtdb.firebaseio.com', 'posts/$postId/likes.json');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newCount),
    );
    if (response.statusCode == 200) {
      // setState(() {
      //   _likeCount = newCount;
      // });
      Provider.of<AppState>(context, listen: false)
          .setLikeCount(postId, newCount);
    }
  }

  void _toggleLike() {
    final appState = Provider.of<AppState>(context, listen: false);
    final currentCount = appState.getLikeCount(widget.postId);
    setState(() {
      _isLiked = !_isLiked;
      // int newCount = _isLiked ? _likeCount + 1 : _likeCount - 1;
      int newCount = _isLiked ? currentCount + 1 : currentCount - 1;
      _updateLikeCount(widget.postId, newCount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      int likeCount = appState.getLikeCount(widget.postId);
      return Column(
        children: [
          TextButton.icon(
            onPressed: _toggleLike,
            icon: _isLiked
                ? Image.asset('assets/images/liked_btn.png', width: 18)
                : Image.asset('assets/images/like_btn.png', width: 18),
            // label: const Text(
            //   '좋아요',
            //   style: TextStyle(color: Colors.grey),
            // )
            label: Text('$likeCount', style: const TextStyle(color: Colors.grey)),
          ),
        ],
      );
    });
  }
}

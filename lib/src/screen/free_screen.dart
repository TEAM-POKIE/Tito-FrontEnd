import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tito_app/src/data/models/freescreen_item.dart';
import 'package:tito_app/src/view/freeView/free_appbar.dart';
import 'package:tito_app/src/view/freeView/free_view.dart';
import 'package:tito_app/src/widgets/free/free_screen_detail.dart';
import 'package:tito_app/src/widgets/free/free_screen_write.dart';
import 'package:tito_app/src/widgets/free/like_button.dart';
import 'package:tito_app/src/widgets/reuse/search_bar.dart';
import 'package:tito_app/src/widgets/reuse/bottombar.dart';
import 'package:tito_app/core/provider/app_state.dart';
import 'package:provider/provider.dart';
import 'package:tito_app/src/widgets/free/comment_button.dart';

import 'package:go_router/go_router.dart';

class FreeScreen extends StatefulWidget {
  const FreeScreen({super.key});

  @override
  State<FreeScreen> createState() => _FreeScreenState();
}

class _FreeScreenState extends State<FreeScreen> {
  List<FreeScreenItem> _freescreenitem = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final url =
        Uri.https('pokeeserver-default-rtdb.firebaseio.com', 'write-post.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> freeListData = json.decode(response.body);
      final List<FreeScreenItem> loadedItems = [];
      for (final entry in freeListData.entries) {
        final itemData = entry.value as Map<String, dynamic>;
        final item = FreeScreenItem(
          id: entry.key,
          title: itemData['title'],
          content: itemData['content'],
          timestamp: DateTime.parse(itemData['timestamp']),
        );
        loadedItems.add(item);
      }
      setState(() {
        _freescreenitem = loadedItems.reversed.toList();
      });
    }
  }

  void _addPost() async {
    final newItem = await context.push<FreeScreenItem>('/write');

    if (newItem == null) {
      return;
    }

    setState(() {
      _freescreenitem.insert(0, newItem);
    });
  }

  void _navigateToDetail(String id) {
    context.push('/detail/$id');
  }

  void _removePost(FreeScreenItem item) {
    setState(() {
      _freescreenitem.remove(item);
    });
  }

  String timeAgo(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);

    if (duration.inDays > 1) {
      return '${duration.inDays}일 전';
    } else if (duration.inDays == 1) {
      return '어제';
    } else if (duration.inHours > 1) {
      return '${duration.inHours}시간 전';
    } else if (duration.inHours == 1) {
      return '한 시간 전';
    } else if (duration.inMinutes > 1) {
      return '${duration.inMinutes}분 전';
    } else if (duration.inMinutes == 1) {
      return '1분 전';
    } else if (duration.inSeconds >= 0) {
      return '방금 전';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: FreeAppbar(),
      ),
      body: FreeView(),
    );
  }

  // Positioned(
  //   bottom: 13,
  //   right: 20,
  //   child: ElevatedButton.icon(
  //     onPressed: () {},
  //     //onPressed: _addPost,
  //     style: ElevatedButton.styleFrom(
  //         backgroundColor: const Color(0xFF111111),
  //         foregroundColor: const Color(0xFFDCF333)),
  //     icon: const Icon(Icons.edit, size: 16),
  //     label: const Text('글쓰기'),
  //   ),
  // ),
}

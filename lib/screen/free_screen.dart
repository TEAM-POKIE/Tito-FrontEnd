import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tito_app/models/freescreen_item.dart';
import 'package:tito_app/widgets/free/free_screen_detail.dart';
import 'package:tito_app/widgets/free/free_screen_write.dart';
import 'package:tito_app/widgets/free/like_button.dart';
import 'package:tito_app/widgets/reuse/search_bar.dart';
import 'package:tito_app/widgets/reuse/bottombar.dart';
import 'package:tito_app/widgets/free/like_button.dart';
import 'package:tito_app/provider/app_state.dart';
import 'package:provider/provider.dart';

import 'package:tito_app/widgets/free/comment_button.dart';


//상태관리 
//보이는 것만 랜더링된다면 훨씬 더 성능이 좋겠지




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
          //likes: itemData['likes'] ?? 0, // 좋아요 수 추가
        );
        loadedItems.add(item);
      }
      setState(() {
        _freescreenitem = loadedItems.reversed.toList();
        // 데이터를 역순으로 정렬하여 상태에 저장
      });
    }
  }

  void _addPost() async {
    final newItem = await Navigator.of(context).push<FreeScreenItem>(
      MaterialPageRoute(
        builder: (ctx) => FreeScreenWrite(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _freescreenitem.insert(0, newItem);
      // 새 게시글을 리스트의 맨 앞에 추가
    });
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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
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
                  itemCount: _freescreenitem.length,
                  itemBuilder: (ctx, index) {
                  
                    final item = _freescreenitem[index];
                    return ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            timeAgo(item.timestamp),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                      onLongPress: () => _removePost(item),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 3.0,
                              ),
                              const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/usericon.png'),
                                radius: 13.0,
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              const Text('타카'),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            item.content,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text('투표'),
                              ),
                              const SizedBox(width: 8.0),
                              const Text('10명 투표 참여'),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              const Text(
                                '좋아요',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(width: 4),
                              const SizedBox(width: 16),
                              const Text('조회수',
                                  style: TextStyle(color: Colors.grey)),
                              const SizedBox(width: 4),
                              const Text('32'),
                            ],
                          ),
                          const SizedBox(height: 15.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              LikeButton(
                                postId: item.id,
                              ),
                              Container(
                                height: 24.0,
                                width: 1.0,
                                color: Colors.grey,
                              ),
                              CommentButton(),
                            ],
                          ),
                          Container(
                            height: 1.0,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 10.0),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FreeScreenDetail(item: item),
                          ),
                        );
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
              onPressed: _addPost,
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

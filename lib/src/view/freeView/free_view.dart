import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:tito_app/src/data/models/freescreen_info.dart';
import 'package:tito_app/src/viewModel/free_viewModel.dart';
import 'package:tito_app/src/widgets/reuse/search_bar.dart';
import 'package:go_router/go_router.dart';

class FreeView extends ConsumerWidget {
  const FreeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const CustomSearchBar(),
        const SizedBox(height: 20),
        Container(
          height: 1.0,
          color: Colors.grey[300],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: freeDummydata.length,
            itemBuilder: (ctx, index) {
              final item = freeDummydata[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InkWell(
                  onTap: () {
                    context.go('/detail');
                    // Navigator.pushNamed(
                    //   context,
                    //   '/write',
                      // arguments: {
                      //   'title': item['Title'],
                      //   'content': item['content'],
                      // },
                    // );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Spacer(),
                          const Padding(
                            padding: EdgeInsets.only(right: 15.0),
                            child: Text(
                              '1분 전',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),

                            // Text(
                            //   timeAgo(item.timestamp),
                            //   style: const TextStyle(
                            //     fontSize: 12,
                            //     color: Colors.grey,
                            //   ),
                            // ),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/chatprofile.png'),
                              radius: 12.0,
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text('타카'),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, top: 30.0, bottom: 20.0),
                            child: Text(
                              item.content,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, bottom: 20.0),
                                child: Container(
                                  width: 350,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFF8E48F8)),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6.0, horizontal: 23.0),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF8E48F8),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(14.0),
                                            bottomLeft: Radius.circular(14.0),
                                            topRight: Radius.circular(12.0),
                                            bottomRight: Radius.circular(12.0),
                                          ),
                                        ),
                                        child: const Text(
                                          '투표',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          '10명 투표 참여',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  '좋아요',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              SizedBox(width: 4),
                              Text('13'),
                              SizedBox(width: 16),
                              Text('조회수', style: TextStyle(color: Colors.grey)),
                              SizedBox(width: 4),
                              Text('32'),
                              SizedBox(width: 16),
                              Text('댓글', style: TextStyle(color: Colors.grey)),
                              SizedBox(width: 4),
                              Text('9'),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Container(
                              height: 1.0,
                              color: Colors.grey[300],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                height: 43.0,
                                width: 1.0,
                                color: Colors.grey,
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  context.go('/detail');
                                },
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
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 13,
          right: 10,
          child: ElevatedButton.icon(
            onPressed: () {
              context.go('/write');
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF111111),
                foregroundColor: const Color(0xFFDCF333)),
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('글쓰기'),
          ),
        ),
      ],
    );
  }
}

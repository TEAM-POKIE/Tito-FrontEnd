import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:tito_app/src/data/models/freescreen_item.dart';
import 'package:tito_app/src/widgets/reuse/search_bar.dart';
import 'package:tito_app/src/widgets/reuse/bottombar.dart';

class FreeView extends ConsumerWidget {
  const FreeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        CustomSearchBar(),
        const SizedBox(height: 20),
        Container(
          height: 1.0,
          color: Colors.grey[300],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _freescreenitem.length,
            itemBuilder: (ctx, index) {
              final item = _freescreenitem[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Row(
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),

                      Spacer(),
                      // Text(
                      //   timeAgo(item.timestamp),
                      //   style: const TextStyle(
                      //     fontSize: 12,
                      //     color: Colors.grey,
                      //   ),
                      // ),
                      const SizedBox(height: 8.0),
                      Column(
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
                          Text(
                            item.content,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8.0),
                          // Row(
                          //   children: [
                          //     ElevatedButton(
                          //       onPressed: () {},
                          //       child: const Text('투표'),
                          //     ),
                          //     const SizedBox(width: 8.0),
                          //     const Text('10명 투표 참여'),
                          //   ],
                          // ),
                          const SizedBox(height: 8.0),
                          // const Row(
                          //   children: [
                          //     Text(
                          //       '좋아요',
                          //       style: TextStyle(color: Colors.grey),
                          //     ),
                          //     SizedBox(width: 4),
                          //     SizedBox(width: 16),
                          //     Text('조회수',
                          //         style: TextStyle(color: Colors.grey)),
                          //     SizedBox(width: 4),
                          //     Text('32'),
                          //   ],
                          // ),
                          // const SizedBox(height: 15.0),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     LikeButton(
                          //       postId: item.id,
                          //     ),
                          //     Container(
                          //       height: 24.0,
                          //       width: 1.0,
                          //       color: Colors.grey,
                          //     ),
                          //     CommentButton(),
                          //   ],
                          // ),
                          // Container(
                          //   height: 1.0,
                          //   color: Colors.grey[300],
                          // ),
                        ],
                      ),
                    ],
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

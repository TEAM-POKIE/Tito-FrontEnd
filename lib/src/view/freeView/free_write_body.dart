import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:tito_app/src/data/models/freescreen_info.dart';
import 'package:tito_app/src/viewModel/free_viewModel.dart';
import 'package:tito_app/src/widgets/reuse/search_bar.dart';
import 'package:tito_app/src/widgets/reuse/bottombar.dart';
import 'package:tito_app/src/widgets/free/like_button.dart';
import 'package:tito_app/src/widgets/free/comment_button.dart';
import 'package:tito_app/core/routes/routes.dart';
import 'package:go_router/go_router.dart';

class FreeWriteBody extends ConsumerWidget {
  const FreeWriteBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            '주제에 대한 내용과 투표 여부를 설정해보세요!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  Text('제목',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10.0),
                  TextField(
                    //controller: _titleController,
                    decoration: InputDecoration(
                      hintText: '입력하세요',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Color(0xFFF6F6F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 30.0),
                  Text('내용',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.0),
                  // Container(
                  //   height: 230.0,
                  //   child: TextField(
                  //     controller: _contentController,
                  //     decoration: InputDecoration(
                  //       contentPadding: EdgeInsets.symmetric(
                  //           horizontal: 10.0, vertical: 250.0),
                  //       hintText: '입력하세요',
                  //       hintStyle: TextStyle(color: Colors.grey),
                  //       filled: true,
                  //       fillColor: Color(0xFFF6F6F6),
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(30.0),
                  //         borderSide: BorderSide.none,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

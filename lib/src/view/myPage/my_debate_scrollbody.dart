import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/screen/home_screen.dart';
import 'package:tito_app/core/constants/style.dart';

class MyDebateScrollbody extends ConsumerWidget {
  const MyDebateScrollbody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 5, //더미데이터 값 일단 5개
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: const ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left:16, right: 16, top:16, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '2024.6.20',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16), // 구분선 추가
                  child: Text(
                    '아싸 애인 VS 인싸 애인',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left:16, right:16,bottom: 16,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '의견: 아싸 애인이 더 좋다',
                        style: TextStyle(color: Colors.black),
                      ),
                      Row(
                        children: [
                          Text(
                            '결과: 승',
                            style: TextStyle(
                              color: ColorSystem.purple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Image(
                            image: AssetImage('assets/images/hotlist.png'),
                            // width: 24,
                            // height: 24,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ),
          );
        });
    //});
  }
}

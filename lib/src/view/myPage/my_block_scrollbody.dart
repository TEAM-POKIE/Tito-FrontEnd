import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/screen/home_screen.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class MyBlockScrollbody extends StatefulWidget {
  @override
  _MyBlockScrollBodyState createState() => _MyBlockScrollBodyState();
}

class _MyBlockScrollBodyState extends State<MyBlockScrollbody> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> _bannedUsers =
      List.generate(15, (index) => '토론 일인자 $index');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: const Text(
            '차단한 유저',
            style: FontSystem.KR16B,
          ),
        ),
        SizedBox(height: 20.h),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: AnimatedList(
              key: _listKey,
              initialItemCount: _bannedUsers.length,
              itemBuilder: (context, index, animation) {
                return _buildItem(context, _bannedUsers[index], animation, index);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, String user,
      Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 22,
            backgroundImage:
                AssetImage('assets/images/hot_fighter.png'), // 이미지 경로 설정
          ),
          title: Text(user,
          style: FontSystem.KR16R,),
          trailing: Container(
            width: 97.w,
            height: 33.h,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)
                )
              ),
              onPressed: () {
                _removeItem(index);
              },
              child: Text('차단 해제', style: FontSystem.KR14R,),
            ),
          ),
        ),
      ),
    );
  }

  void _removeItem(int index) {
    String removedUser = _bannedUsers.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) =>
          _buildItem(context, removedUser, animation, index),
      duration: Duration(milliseconds: 300),
    );
  }
}

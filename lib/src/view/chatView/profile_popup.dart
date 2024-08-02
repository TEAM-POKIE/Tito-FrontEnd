import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePopup extends StatefulWidget {
  @override
  _ProfilePopupState createState() => _ProfilePopupState();
}

class _ProfilePopupState extends State<ProfilePopup> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> _items = []; //아이템 리스트

  @override
  void initState() {
    super.initState();
    _addItems();
  }

  void _addItems() {
    for (int i = 0; i < 4; i++) {
      _items.add('Item $i');
      _listKey.currentState?.insertItem(_items.length - 1); //애니메이션과 함께 아이템 삽입
    }
  }

  Widget _buildItem(String item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: ListTile(
        title: const Text(
          '아싸 애인 vs 인싸 애인',
          style: FontSystem.KR16R,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('의견: 아싸 애인이 더 좋다', style: FontSystem.KR14R),
            Text('결과: 승',
                style: FontSystem.KR14R.copyWith(color: ColorSystem.purple))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        //width: 
        child: Column(
          children: [
            const Text('프로필', style: FontSystem.KR14R),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
            ),
            Column(
              children: [
                //SizedBox(height: 42.h),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 68.w),
                      child: ClipOval(
                        child: SvgPicture.asset(
                          'assets/icons/profile.svg',
                          width: 70.w,
                          height: 70.h, // SVG 이미지 경로// 이미지 맞춤 설정
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('포키', style: FontSystem.KR24B),
                          SizedBox(height: 4),
                          Text('승률 80%',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.purple)),
                          SizedBox(height: 4),
                          Text('12전 | 10승 | 2패',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text('참여한 토론',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Expanded(
                  child: AnimatedList(
                    key: _listKey,
                    initialItemCount: _items.length,
                    itemBuilder: (context, index, animation) {
                      return _buildItem(_items[index], animation);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

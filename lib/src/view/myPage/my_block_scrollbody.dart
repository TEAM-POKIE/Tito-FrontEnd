import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/src/data/models/get_user_block.dart';

class MyBlockScrollbody extends StatefulWidget {
  @override
  _MyBlockScrollBodyState createState() => _MyBlockScrollBodyState();
}

class _MyBlockScrollBodyState extends State<MyBlockScrollbody> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<GetUserBlock> _bannedUsers = []; // 차단된 유저 목록을 담을 리스트

  @override
  void initState() {
    super.initState();
    _fetchBlockedList(); // 위젯이 초기화될 때 차단된 유저 목록을 가져옵니다.
  }

  // 차단된 유저 목록을 API에서 가져오는 메서드
  void _fetchBlockedList() async {
    try {
      final List<GetUserBlock> response =
          await ApiService(DioClient.dio).getBlockedUser();
      setState(() {
        _bannedUsers = response; // 가져온 데이터를 리스트에 반영
      });
    } catch (e) {
      print('차단된 유저 목록을 가져오는 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            '차단한 유저',
            style: FontSystem.KR16B,
          ),
        ),
        SizedBox(height: 20.h),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: _bannedUsers.isEmpty
                ? Center(child: Text('차단한 유저가 없습니다.'))
                : AnimatedList(
                    key: _listKey,
                    initialItemCount: _bannedUsers.length,
                    itemBuilder: (context, index, animation) {
                      return _buildItem(
                          context, _bannedUsers[index], animation, index);
                    },
                  ),
          ),
        ),
      ],
    );
  }

  // 개별 항목을 생성하는 메서드
  Widget _buildItem(BuildContext context, GetUserBlock user,
      Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 22,
            backgroundImage: user.profilePicture != null
                ? NetworkImage(user.profilePicture!) // API에서 받은 프로필 이미지 사용
                : AssetImage('assets/images/hot_fighter.png')
                    as ImageProvider, // 기본 이미지 경로 설정
          ),
          title: Text(
            user.nickname, // API에서 받은 닉네임을 표시
            style: FontSystem.KR16R,
          ),
          trailing: Container(
            width: 97.w,
            height: 33.h,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r))),
              onPressed: () {
                _removeItem(index);
              },
              child: Text(
                '차단 해제',
                style: FontSystem.KR14R,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 차단 해제 버튼을 누를 때 호출되는 메서드
  void _removeItem(int index) async {
    // await ApiService(DioClient.dio).deleteUnblock(_bannedUsers.id);
    String removedUserNickname = _bannedUsers[index].nickname; // 닉네임 저장
    _bannedUsers.removeAt(index); // 리스트에서 유저를 제거
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildItem(context,
          GetUserBlock(id: 0, nickname: removedUserNickname), animation, index),
      duration: Duration(milliseconds: 300),
    );
  }
}

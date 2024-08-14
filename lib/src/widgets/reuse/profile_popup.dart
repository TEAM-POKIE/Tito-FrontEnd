import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/src/data/models/debate_usermade.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:tito_app/core/provider/userProfile_provider.dart';

class ProfilePopup extends ConsumerStatefulWidget {
  const ProfilePopup({super.key});

  @override
  ConsumerState<ProfilePopup> createState() {
    return _ProfilePopupState();
  }
}

class _ProfilePopupState extends ConsumerState<ProfilePopup> {
  List<DebateUsermade> debateList = [];

  @override
  void initState() {
    super.initState();
    _fetchList(); // 토론 목록을 가져오는 함수 호출
  }

  void _fetchList() async {
    final chatState = ref.read(chatInfoProvider);
    final userState = ref.read(userProfileProvider);
    try {
      // Map<String, dynamic> 타입으로 응답을 받아옴
      final Map<String, dynamic> debateResponse =
          await ApiService(DioClient.dio).getOtherDebate(userState!.id);

      // 응답에서 'data' 필드를 추출하여 List<dynamic>로 변환
      final List<dynamic> data = debateResponse['data'];

      // 'data' 리스트의 각 항목을 'DebateUsermade' 객체로 변환
      final List<DebateUsermade> debates = data.map((item) {
        if (item is DebateUsermade) {
          return item; // 이미 DebateUsermade 객체라면 그대로 사용
        } else {
          return DebateUsermade.fromJson(item as Map<String, dynamic>);
        }
      }).toList();

      setState(() {
        debateList = debates; // 변환된 리스트를 상태에 저장
      });
    } catch (error) {
      print('Error fetching debate list: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorSystem.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        width: 350.w,
        height: 580.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 19.h),
            Row(
              children: [
                SizedBox(width: 140.w),
                const Text('프로필', style: FontSystem.KR14B),
                SizedBox(width: 80.w),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            _buildProfileHeader(ref),
            const Divider(
              color: ColorSystem.grey3,
              thickness: 2,
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const Text(
                '참여한 토론',
                style: FontSystem.KR14B,
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.builder(
                itemCount: debateList.length,
                itemBuilder: (context, index) {
                  return _buildListItem(debateList[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(WidgetRef ref) {
    final userState = ref.read(userProfileProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 25.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 35.r, // 아이콘 크기
                backgroundImage: NetworkImage(userState!.profilePicture),
                onBackgroundImageError: (_, __) {
                  // 이미지 로드 오류 처리
                },
              ),
              SizedBox(width: 15.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('${userState!.nickname}', style: FontSystem.KR24B),
                      SizedBox(width: 5.w),
                      Container(
                        decoration: BoxDecoration(
                            color: ColorSystem.lightPurple,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: ColorSystem.purple,
                            )),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.h, vertical: 6.h),
                          child: Text('승률 ${userState.winningRate}%',
                              textAlign: TextAlign.center,
                              style: FontSystem.KR14B
                                  .copyWith(color: ColorSystem.purple)),
                        ),
                      ),
                    ],
                  ),
                  Text(
                      '${userState.debateTotalCount}전 | ${userState.debateVictoryCount}승 | ${userState.debateDefeatCount}패',
                      style: FontSystem.KR18R),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(DebateUsermade debate) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: const [
            BoxShadow(
              color: Color(0x669795A3),
              spreadRadius: 0,
              blurRadius: 4,
            )
          ],
        ),
        child: ListTile(
          title: Text(
            debate.debateTitle,
            style: FontSystem.KR15B,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '의견: ${debate.debateMakerOpinion}',
                style: FontSystem.KR14R.copyWith(color: ColorSystem.grey),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              if (debate.isWinOrLoose == true)
                Text(
                  '결과: 승',
                  style: FontSystem.KR14R.copyWith(color: ColorSystem.purple),
                )
              else if (debate.isWinOrLoose == null)
                Text(
                  '결과: 패',
                  style: FontSystem.KR14R.copyWith(color: ColorSystem.purple),
                )
              else
                Text(
                  '결과: 무',
                  style: FontSystem.KR14R.copyWith(color: ColorSystem.purple),
                )
            ],
          ),
        ),
      ),
    );
  }
}

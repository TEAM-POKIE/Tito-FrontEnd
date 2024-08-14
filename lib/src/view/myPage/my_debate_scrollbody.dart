import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tito_app/src/screen/home_screen.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/src/data/models/debate_list.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/core/provider/websocket_provider.dart';
import 'package:tito_app/src/data/models/debate_usermade.dart';

class MyDebateScrollbody extends ConsumerStatefulWidget {
  const MyDebateScrollbody({super.key});

  @override
  _MyDebateScrollbodyState createState() => _MyDebateScrollbodyState();
}

class _MyDebateScrollbodyState extends ConsumerState<MyDebateScrollbody> {
  List<DebateUsermade> debateList = [];

  @override
  void initState() {
    super.initState();
    _madeInDebate(); // 위젯 초기화 시 _madeInDebate 호출
  }

  Future<void> _madeInDebate({bool isRefresh = false}) async {
    try {
      // Map<String, dynamic> 타입으로 응답을 받아옴
      final Map<String, dynamic> debateResponse =
          await ApiService(DioClient.dio).getUserDebate();

      // 응답에서 'data' 필드를 추출하여 List<DebateUsermade>로 캐스팅
      final List<dynamic> data = debateResponse['data'];

      // 만약 데이터가 이미 DebateUsermade 타입인 경우 변환하지 않고 사용
      final List<DebateUsermade> debates = data.map((item) {
        if (item is DebateUsermade) {
          return item; // 이미 DebateUsermade 객체라면 그대로 사용
        } else {
          return DebateUsermade.fromJson(item as Map<String, dynamic>);
        }
      }).toList();

      setState(() {
        debateList = debates; // 변환된 리스트를 할당
      });
    } catch (error) {
      print('Error fetching debate list: $error');
    }
  }

  String _formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    return DateFormat('yyyy.M.d').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: debateList.length,
      itemBuilder: (context, index) {
        final debate = debateList[index];
        return _buildItem(context, debate);
      },
    );
  }

  Widget _buildItem(BuildContext context, DebateUsermade debate) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: Row(
        children: [
          Container(
            width: 350.w,
            height: 120.h,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0x669795A3),
                  spreadRadius: 0,
                  blurRadius: 4,
                )
              ],
              color: ColorSystem.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 0.w),
                    child: Text(
                      _formatDate(debate.createdAt),
                      style:
                          TextStyle(fontSize: 14.sp, color: ColorSystem.grey),
                    ),
                  ),
                  Divider(color: ColorSystem.grey),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 0.w),
                        child: Text(
                          '${debate.debateTitle}',
                          style: FontSystem.KR15B,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Padding(
                        padding: EdgeInsets.only(left: 0.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${debate.debateMakerOpinion}',
                              style: FontSystem.KR14R
                                  .copyWith(color: ColorSystem.grey),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 0.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (debate.isWinOrLoose == true)
                                    Text(
                                      '결과: 승',
                                      style: FontSystem.KR14R
                                          .copyWith(color: ColorSystem.purple),
                                    )
                                  else if (debate.isWinOrLoose == null)
                                    Text(
                                      '결과: 패',
                                      style: FontSystem.KR14R
                                          .copyWith(color: ColorSystem.purple),
                                    )
                                  else
                                    Text(
                                      '결과: 무',
                                      style: FontSystem.KR14R
                                          .copyWith(color: ColorSystem.purple),
                                    )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

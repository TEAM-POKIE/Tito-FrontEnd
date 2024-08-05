import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/screen/home_screen.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/src/data/models/debate_list.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/core/provider/websocket_provider.dart';
import 'package:tito_app/src/data/models/debate_usermade.dart';
import 'package:tito_app/src/data/models/debate_list.dart';

class MyDebateScrollbody extends ConsumerStatefulWidget {
  const MyDebateScrollbody({super.key});

  @override
  _MyDebateScrollbodyState createState() => _MyDebateScrollbodyState();
}

class _MyDebateScrollbodyState extends ConsumerState<MyDebateScrollbody> {
  final List<int> _items = List<int>.generate(5, (int index) => index);
  List<Debate> debateList = [];


  Future<void> _madeInDebate({bool isRefresh = false}) async {
    try {
      final List<Debate> debateResponse =
          await ApiService(DioClient.dio).getDebateList();

      setState(() {
        debateList = debateResponse.map((debate) {
          return Debate(
            id: debate.id,
            debateTitle: debate.debateTitle, 
            debateCategory:
                DebateListCategory.fromString(debate.debateCategory).toString(),
            debateStatus:
                DebateListStatus.fromString(debate.debateStatus).toString(),
            debateMakerOpinion: debate.debateMakerOpinion,
            debateJoinerOpinion: debate.debateJoinerOpinion,
            debatedTimeLimit: debate.debatedTimeLimit,
            debateViewCount: debate.debateViewCount,
            debateCommentCount: debate.debateCommentCount,
            debateRealtimeParticipants: debate.debateRealtimeParticipants,
            debateAlarmCount: debate.debateAlarmCount,
            createdAt: debate.createdAt,
            updatedAt: debate.updatedAt,
          );
        }).toList();
      });
    } catch (error) {
      print('Error fetching debate list: $error');
    }
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

  Widget _buildItem(BuildContext context, Debate debate) {
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
                      '${debate.createdAt}',
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
                            // Text(
                            //   '${debate.de}',
                            //   style: FontSystem.KR14R
                            //       .copyWith(color: ColorSystem.grey),
                            //   overflow: TextOverflow.ellipsis,
                            //   maxLines: 1,
                            // ),
                            Padding(
                              padding: EdgeInsets.only(left: 0.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '결과: 승',
                                    style: FontSystem.KR14R
                                        .copyWith(color: ColorSystem.purple),
                                  ),
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

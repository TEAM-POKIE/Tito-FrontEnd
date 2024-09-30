import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/src/data/models/debate_usermade.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';

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
    _madeInDebate();
  }

  Future<void> _madeInDebate({bool isRefresh = false}) async {
    try {
      final String response = await ApiService(DioClient.dio).getUserDebate();

      final Map<String, dynamic> decodedResponse =
          json.decode(response) as Map<String, dynamic>;

      final List<dynamic> dataList = decodedResponse['data'] as List<dynamic>;

      final List<DebateUsermade> debates = dataList
          .map((item) => DebateUsermade.fromJson(item as Map<String, dynamic>))
          .toList();

      setState(() {
        debateList = debates;
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
        return GestureDetector(
          onTap: () {
            context.push('/chat/${debate.id}');
          },
          child: _buildItem(context, debate),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, DebateUsermade debate) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
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
                      style: FontSystem.KR14M.copyWith(color: ColorSystem.grey),
                    ),
                  ),
                  const Divider(
                    color: ColorSystem.grey,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 0.w),
                              child: Text(
                                maxLines: 1,
                                '${debate.debateTitle}',
                                style: FontSystem.KR15B,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              width: 100.w,
                              child: Padding(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (debate.isWinOrLoose == true)
                                            Text(
                                              '결과: 승',
                                              style: FontSystem.KR14R.copyWith(
                                                  color: ColorSystem.purple),
                                            )
                                          else if (debate.isWinOrLoose == null)
                                            Text(
                                              '결과: 패',
                                              style: FontSystem.KR14R.copyWith(
                                                  color: ColorSystem.purple),
                                            )
                                          else
                                            Text(
                                              '결과: 무',
                                              style: FontSystem.KR14R.copyWith(
                                                  color: ColorSystem.purple),
                                            )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: debate.debateImageUrl == ''
                            ? SvgPicture.asset(
                                'assets/icons/list_real_null.svg',
                                width: 70.w, // 원하는 너비 설정
                                fit: BoxFit.contain,
                              )
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(12.r), // 둥근 모서리 설정
                                child: Image.network(
                                  debate.debateImageUrl ?? '',
                                  width: 60.w, // 원하는 너비 설정
                                  height: 60.h,
                                  fit: BoxFit.cover, // 이미지가 잘리지 않도록 맞춤 설정
                                ),
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

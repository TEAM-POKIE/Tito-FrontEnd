import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/websocket_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/src/data/models/debate_list.dart';
import 'package:tito_app/src/widgets/reuse/search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';

class ListScreen extends ConsumerStatefulWidget {
  const ListScreen({super.key});

  @override
  ConsumerState<ListScreen> createState() {
    return _ListScreenState();
  }
}

class _ListScreenState extends ConsumerState<ListScreen> {
  final List<String> labels = ['연애', '정치', '연예', '자유', '스포츠'];
  final List<String> statuses = ['전체', '실시간', '종료'];
  final List<String> sortOptions = ['최신순', '인기순'];
  int categorySelectedIndex = 0;
  int textSelectedIndex = 0;
  String selectedStatus = '전체';
  String selectedSortOption = '최신순';
  List<Debate> debateList = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    //Widget tree의 초기화
    super.initState();
    final loginInfo = ref.read(loginInfoProvider);
    print(loginInfo!.nickname);
    _fetchDebateList();
  }

// 아래로 내렸을 때 새로고침 되는 코드
  void _onRefresh() async {
    await _fetchDebateList();
    // await _fetchDebateList(isRefresh: true); // 새로고침 시 기존 데이터를 대체
    _refreshController.refreshCompleted();
  }

// 리스트 끝에 도달했을 때 호출되는 코드
  void _onLoading() async {
    await _fetchDebateList();
    // await _fetchDebateList(isRefresh: false); // 로딩 시 데이터를 추가
    _refreshController.loadComplete();
  }

  void _enterChat(debateId) {
    context.push('/chat/${debateId}');
  }

// 데이터 fetch 로직 : 새로고침 시 기존데이터를 대체하고 리스트 끝에서 다시 렌더링시키기
  Future<void> _fetchDebateList({bool isRefresh = false}) async {
    try {
      final List<Debate> debateResponse =
          await ApiService(DioClient.dio).getDebateList('recentUpdate');

      setState(() {
        debateList = debateResponse;
      });
    } catch (error) {
      print('Error fetching debate list: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Padding(
          padding: EdgeInsets.only(top: 10.w),
          child: AppBar(
            backgroundColor: ColorSystem.white,
            title: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: const Text(
                '토론 리스트',
                style: FontSystem.KR22B,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: const CustomSearchBar(),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: Container(
              //카테고리 바가 들어가는 Container 부분
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // 수평 스크롤 가능하게 설정
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(labels.length, (index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: Container(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              categorySelectedIndex = index;
                              _fetchDebateList();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: categorySelectedIndex == index
                                ? ColorSystem.black
                                : ColorSystem.ligthGrey,
                            foregroundColor: categorySelectedIndex == index
                                ? ColorSystem.white
                                : ColorSystem.grey1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              side: BorderSide(
                                color: categorySelectedIndex == index
                                    ? ColorSystem.black // 선택된 경우 테두리 색상
                                    : ColorSystem.grey3, // 선택되지 않은 경우 테두리 색상
                                width: 1.5, // 테두리 두께
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                labels[index],
                                style: categorySelectedIndex == index
                                    ? FontSystem.KR16SB
                                        .copyWith(color: ColorSystem.white)
                                    : FontSystem.KR16M.copyWith(
                                        color: ColorSystem.grey1,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(statuses.length, (index) {
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              textSelectedIndex = index; // selectedIndex를 업데이트
                              selectedStatus = statuses[index];
                              _fetchDebateList();
                            });
                          },
                          child: Text(
                            statuses[index],
                            style: textSelectedIndex == index
                                ? FontSystem.KR16SB
                                    .copyWith(color: ColorSystem.black)
                                : FontSystem.KR16M.copyWith(
                                    color: ColorSystem.grey1,
                                  ),
                          ),
                        ),
                        if (index < statuses.length - 1)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.h),
                            child: Text('|',
                                style: FontSystem.KR16M
                                    .copyWith(color: ColorSystem.grey)),
                          ),
                      ],
                    );
                  }),
                ),
                DropdownButton<String>(
                  value: selectedSortOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSortOption = newValue!;
                      _fetchDebateList(); // 정렬 옵션을 적용하여 리스트를 다시 가져옵니다.
                    });
                  },
                  items:
                      sortOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style:
                            FontSystem.KR14M.copyWith(color: ColorSystem.grey),
                      ),
                    );
                  }).toList(),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: ColorSystem.grey,
                    size: 20.sp,
                  ),
                  underline: SizedBox.shrink(), // 밑줄을 없애기 위해 사용
                  style: FontSystem.KR14M.copyWith(color: ColorSystem.grey),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: Padding(
                padding: EdgeInsets.only(right: 0.0.w),
                child: Scrollbar(
                  thumbVisibility: true,
                  thickness: 8.0,
                  radius: Radius.circular(20.r),
                  child: ListView.builder(
                    itemCount: debateList.length,
                    itemBuilder: (context, index) {
                      final debate = debateList[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.h, vertical: 5.w),
                        child: Container(
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
                            onTap: () {
                              _enterChat(debate.id);
                            },
                            title: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0.h, vertical: 2.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8.h),
                                  // 여기에 토론 완료 가은 거 추가로 lightGrey 색깔 만들어서 넣어야 하는 코드 위치
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                      color: debate.debateStatus == '실시간'
                                          ? ColorSystem.lightPurple
                                          : ColorSystem.lightPurple,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Text(debate.debateStatus ?? '상태 없음',
                                        style: FontSystem.KR14SB.copyWith(
                                          color: debate.debateStatus == '실시간'
                                              ? ColorSystem.purple
                                              : ColorSystem.purple,
                                        )),
                                        
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    debate.debateTitle ?? 'No title',
                                    style: FontSystem.KR18M.copyWith(height: 1),
                                    maxLines: 1, // 텍스트를 한 줄로 제한 
                                    overflow:
                                        TextOverflow.ellipsis, // 넘칠 경우 "..." 처리
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '제한 시간: ${debate.debatedTimeLimit}분',
                                    style: FontSystem.KR16M
                                        .copyWith(color: ColorSystem.purple),
                                    maxLines: 1, // 텍스트를 한 줄로 제한
                                    overflow:
                                        TextOverflow.ellipsis, // 넘칠 경우 "..." 처리
                                  ),
                                ],
                              ),
                            ),
                            trailing: Container(
                              width: 100.w,
                              height: 100.h,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 20.w),
                                child: SvgPicture.asset(
                                  'assets/icons/list_real_null.svg',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

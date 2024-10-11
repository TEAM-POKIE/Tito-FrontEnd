import 'dart:convert';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/src/data/models/debate_list.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';

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
  int page = 0;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final loginInfo = ref.read(loginInfoProvider);

    _fetchDebateList();
  }

  void _onRefresh() async {
    page = 0;
    await _fetchDebateList();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    page += 1;
    await _fetchDebateList();
    _refreshController.loadComplete();
  }

  Future<void> _fetchDebateList({bool isRefresh = false}) async {
    try {
      String sortBy = _convertSortOption(selectedSortOption);
      String status = _convertStatus(selectedStatus);
      String category = _convertCategory(labels[categorySelectedIndex]);

      // API에서 원시 JSON 문자열을 받아옴
      final String response = await ApiService(DioClient.dio).getDebateList(
        page: page,
        sortBy: sortBy,
        status: status,
        category: category,
      );

      // JSON 문자열을 Map<String, dynamic>으로 디코딩
      final Map<String, dynamic> decodedResponse =
          json.decode(response) as Map<String, dynamic>;

      // 응답에서 'data' 키의 값을 추출하여 List<dynamic>으로 변환
      final List<dynamic> dataList = decodedResponse['data'] as List<dynamic>;

      // List<Map<String, dynamic>>를 List<Debate>로 변환
      final List<Debate> debateResponse = dataList
          .map((item) => Debate.fromJson(item as Map<String, dynamic>))
          .toList();

      setState(() {
        debateList = debateResponse;
      });
    } catch (error) {
      print('Error fetching debate list: $error');
    }
  }

  String _convertSortOption(String sortOption) {
    switch (sortOption) {
      case '최신순':
        return 'latest';
      case '인기순':
        return 'popularity';
      default:
        return 'latest';
    }
  }

  String _convertStatus(String status) {
    switch (status) {
      case '전체':
        return 'allStatus';
      case '실시간':
        return 'realTime';
      case '종료':
        return 'end';
      default:
        return 'allStatus';
    }
  }

  String _convertCategory(String category) {
    switch (category) {
      case '연애':
        return 'ROMANCE';
      case '정치':
        return 'POLITICS';
      case '연예':
        return 'ENTERTAINMENT';
      case '자유':
        return 'FREE';
      case '스포츠':
        return 'SPORTS';
      default:
        return 'allCategory';
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatViewModel = ref.watch(chatInfoProvider.notifier);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Padding(
          padding: EdgeInsets.only(top: 10.w),
          child: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: ColorSystem.white,
            centerTitle: false,
            title: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Text('토론 리스트', style: FontSystem.KR22B),
            ),
            leadingWidth: 69.41.w,
            actions: [
              IconButton(
                onPressed: () {
                  context.push('/search');
                },
                icon: SizedBox(
                  child: Padding(
                    padding: EdgeInsets.only(right: 24.w),
                    child: SvgPicture.asset('assets/icons/new_search.svg'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(labels.length, (index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            categorySelectedIndex = index;
                            _fetchDebateList(isRefresh: true);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: categorySelectedIndex == index
                              ? ColorSystem.black
                              : ColorSystem.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            side: BorderSide(
                              color: categorySelectedIndex == index
                                  ? ColorSystem.black
                                  : ColorSystem.grey5,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          labels[index],
                          style: categorySelectedIndex == index
                              ? FontSystem.KR16SB
                                  .copyWith(color: ColorSystem.white)
                              : FontSystem.KR16M
                                  .copyWith(color: ColorSystem.grey1),
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
                              textSelectedIndex = index;
                              selectedStatus = statuses[index];
                              _fetchDebateList(isRefresh: true);
                            });
                          },
                          child: Text(
                            statuses[index],
                            style: textSelectedIndex == index
                                ? FontSystem.KR16SB
                                    .copyWith(color: ColorSystem.black)
                                : FontSystem.KR16M
                                    .copyWith(color: ColorSystem.grey1),
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
                      _fetchDebateList(isRefresh: true);
                    });
                  },
                  items:
                      sortOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: FontSystem.KR14M
                              .copyWith(color: ColorSystem.grey)),
                    );
                  }).toList(),
                  icon: Icon(Icons.keyboard_arrow_down,
                      color: ColorSystem.grey, size: 20.sp),
                  underline: SizedBox.shrink(),
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
                  controller: _scrollController,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: debateList.length,
                    itemBuilder: (context, index) {
                      final debate = debateList[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.h, vertical: 5.w),
                        child: GestureDetector(
                          onTap: () {
                            chatViewModel.enterChat(
                                debate.id, debate.debateStatus, context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 10.w),
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0x669795A3), blurRadius: 4)
                              ],
                              color: ColorSystem.white,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(
                                              debate.debateStatus),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        child: Text(
                                          _getStatusText(debate.debateStatus),
                                          style: FontSystem.KR14SB.copyWith(
                                              color: _getSubTextColor(debate)),
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        debate.debateTitle,
                                        style: FontSystem.KR16M
                                            .copyWith(height: 1.2),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        _getSubText(debate),
                                        style: FontSystem.KR16M.copyWith(
                                            color: ColorSystem.purple),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                debate.debateImageUrl == ''
                                    ? SvgPicture.asset(
                                        'assets/icons/list_real_null.svg',
                                        width: 100.w)
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        child: Image.network(
                                          debate.debateImageUrl ?? '',
                                          width: 100.w,
                                          height: 80.h,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ],
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

  String _getStatusText(String debateStatus) {
    switch (debateStatus) {
      case 'CREATED':
        return '상대 찾는 중';
      case 'IN_PROGRESS':
        return '토론 진행중';
      case 'VOTING':
        return '투표 중';
      case 'ENDED':
        return '투표 종료';
      default:
        return '상태 없음';
    }
  }

  String _getSubText(Debate debate) {
    switch (debate.debateStatus) {
      case 'CREATED':
        return '${debate.debateOwnerNickname}님이 대기 중';
      case 'IN_PROGRESS':
        return '${debate.debateOwnerNickname}님과 ${debate.debateJoinerNickname}님이 토론 중';
      case 'VOTING':
        return '나도 투표 참여하러 가기';
      case 'ENDED':
        return '토론 결과 확인하러가기';
      default:
        return '';
    }
  }

  Color _getSubTextColor(Debate debate) {
    switch (debate.debateStatus) {
      case 'CREATED':
        return ColorSystem.white;
      case 'IN_PROGRESS':
        return ColorSystem.purple;
      case 'VOTING':
        return ColorSystem.grey1;
      case 'ENDED':
        return ColorSystem.grey1;
      default:
        return ColorSystem.purple;
    }
  }
}

Color _getStatusColor(String? status) {
  switch (status) {
    case 'CREATED':
      return ColorSystem.lightPurple2; // CREATED 상태의 배경색
    case 'IN_PROGRESS':
      return ColorSystem.lightPurple; // IN_PROGRESS 상태의 배경색
    case 'VOTING':
      return ColorSystem.lightYellow; // VOTING 상태의 배경색
    case 'ENDED':
      return ColorSystem.turquoise; // ENDED 상태의 배경색
    default:
      return ColorSystem.lightPurple; // 기본 배경색
  }
}

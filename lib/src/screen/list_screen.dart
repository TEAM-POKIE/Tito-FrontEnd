import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/websocket_provider.dart';
import 'package:tito_app/src/data/models/debate_crate.dart';
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
  final List<String> statuses = ['전체', '토론 중', '토론 종료'];
  final List<String> sortOptions = ['최신순', '인기순'];
  int selectedIndex = 0;
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

  void _onRefresh() async {
    await _fetchDebateList();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await _fetchDebateList();
    _refreshController.loadComplete();
  }

  void _enterChat(debateId) {
    final webSocketService = ref.read(webSocketProvider);
    final loginInfo = ref.read(loginInfoProvider);
    // DebateCreateState를 활용하여 메시지 생성

    // JSON 객체를 생성하여 문자열로 인코딩
    final jsonMessage = json.encode({
      'command': "ENTER",
      'debateId': debateId,
      'userId': loginInfo!.id,
      'content': null,
    });

    // WebSocket을 통해 메시지 전송
    webSocketService.sendMessage(jsonMessage);
    context.push('/chat');
  }

  Future<void> _fetchDebateList() async {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('토론 리스트'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w,),
            child: const CustomSearchBar(),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              width: 360.w,
              height: 30.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(labels.length, (index) {
                  return Flexible(
                    child: Container(
                      height: 30.h,
                      width: 66.w,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedIndex = index;
                            _fetchDebateList();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          textStyle: FontSystem.KR10R,
                          backgroundColor: selectedIndex == index
                              ? ColorSystem.black
                              : Colors.grey[200],
                          foregroundColor: selectedIndex == index
                              ? ColorSystem.white
                              : const Color.fromARGB(255, 101, 101, 101),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              labels[index],
                              style: TextStyle(fontSize: 10.sp),
                              // style: FontSystem.KR10B,
                            ),
                          ],
                        ),
                      ),
                      child: Text(
                        labels[index],
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          SizedBox(height: 45.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: List.generate(statuses.length, (index) {
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedStatus = statuses[index];
                            _fetchDebateList();
                          });
                        },
                        child: Text(
                          statuses[index],
                          style: TextStyle(
                            color: selectedStatus == statuses[index]
                                ? ColorSystem.black
                                : ColorSystem.grey,
                            fontWeight: selectedStatus == statuses[index]
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (index < statuses.length - 1)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.h),
                          child:
                              Text('|', style: TextStyle(color: ColorSystem.grey)),
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
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 8.0,
                radius: Radius.circular(20.r),
                child: ListView.builder(
                  itemCount: debateList.length,
                  itemBuilder: (context, index) {
                    final debate = debateList[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          onTap: () {
                            _enterChat(debate.id);
                          },
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: debate.debateStatus == '토론 중'
                                      ? Colors.purple[100]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  debate.debateStatus ?? '상태 없음',
                                  style: TextStyle(
                                    color: debate.debateStatus == '토론 중'
                                        ? Colors.purple
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                debate.debateTitle ?? 'No title',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '제한 시간: ${debate.debatedTimeLimit}분',
                              ),
                            ],
                          ),
                          trailing: Image.asset(
                            'assets/images/hotlist.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

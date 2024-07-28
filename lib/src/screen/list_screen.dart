import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/src/data/models/debate_list.dart';
import 'dart:convert';
import 'package:tito_app/src/widgets/reuse/search_bar.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListScreen extends ConsumerStatefulWidget {
  const ListScreen({super.key});

  @override
  ConsumerState<ListScreen> createState() {
    return _ListScreenState();
  }
}

class _ListScreenState extends ConsumerState<ListScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final List<String> labels = ['연애', '정치', '연예', '자유', '스포츠'];
  final List<String> statuses = ['전체', '토론 중', '토론 종료'];
  final List<String> sortOptions = ['최신순', '인기순'];
  int selectedIndex = 0;
  String selectedStatus = '전체';
  String selectedSortOption = '최신순';
  List<Map<String, dynamic>> debateList = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _fetchDebateList();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await _fetchDebateList();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await _fetchDebateList();
    _refreshController.loadComplete();
  }

  Future<void> _fetchDebateList() async {
    try {
      // ApiService에서 Debate 리스트를 받아옴
      final List<Debate> debateResponse =
          await ApiService(DioClient.dio).getDebateList();

      // 선택된 정렬 옵션에 따라 정렬
      if (selectedSortOption == '최신순') {
        debateResponse.sort((a, b) {
          DateTime dateA = DateTime.parse(a.updatedAt);
          DateTime dateB = DateTime.parse(b.updatedAt);
          return dateB.compareTo(dateA); // 내림차순으로 정렬
        });
      }

      // 상태가 마운트된 경우 state 설정
      if (mounted) {
        setState(() {
          debateList = debateResponse
              .map((debate) => {
                    'id': debate.id,
                    'title': debate.debateTitle,
                    'debateStatus': debate.debateStatus,
                    'debateMakerOpinion': debate.debateMakerOpinion,
                    'debateJoinerOpinion': debate.debateJoinerOpinion,
                    'timestamp': debate.updatedAt,
                  })
              .toList();
        });
      }
    } catch (error) {
      // 에러 처리
      print('Error fetching debate list: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginInfo = ref.watch(loginInfoProvider);

    // 선택된 카테고리와 상태에 따라 필터링된 리스트 생성
    List<Map<String, dynamic>> filteredDebateList = debateList.where((debate) {
      final categoryMatch = debate['category'] == labels[selectedIndex];
      bool statusMatch = true;

      if (selectedStatus == '토론 중') {
        statusMatch = debate['debateState'] == '토론 참여가능' ||
            debate['debateState'] == '토론 진행중';
      } else if (selectedStatus == '토론 종료') {
        statusMatch =
            debate['debateState'] == '투표 중' || debate['debateState'] == '투표 완료';
      }

      return categoryMatch && (statusMatch || selectedStatus == '전체');
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('토론 리스트'),
        centerTitle: true, // 타이틀 중앙 정렬
      ),
      body: Column(
        children: [
          const CustomSearchBar(),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(labels.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: SizedBox(
                    height: 40,
                    width: (MediaQuery.of(context).size.width - 40) * 0.2,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIndex = index;
                          _fetchDebateList();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        backgroundColor: selectedIndex == index
                            ? Colors.black
                            : Colors.grey[200],
                        foregroundColor: selectedIndex == index
                            ? Colors.white
                            : const Color.fromARGB(255, 101, 101, 101),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        labels[index],
                        style: TextStyle(fontSize: 10),
                        // style: FontSystem.KR10B,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          Row(
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
                                ? Colors.black
                                : Colors.grey,
                            fontWeight: selectedStatus == statuses[index]
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (index < statuses.length - 1)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child:
                              Text('|', style: TextStyle(color: Colors.grey)),
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
          const SizedBox(height: 20),
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
                radius: const Radius.circular(20.0),
                child: ListView.builder(
                  itemCount: filteredDebateList.length,
                  itemBuilder: (context, index) {
                    final debate = filteredDebateList[index];

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
                            final debateState = debate['debateState'] ?? '';

                            if (debate['id'] != null) {
                              if (debateState == '토론 참여가능' ||
                                  debateState == '토론 진행중') {
                                context.push('/chat/${debate['id']}');
                              }
                            } else {
                              print('Invalid ID for Chat page.');
                            }
                          },
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: debate['debateState'] == '토론 중'
                                      ? Colors.purple[100]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  debate['debateState'] ?? '상태 없음',
                                  style: TextStyle(
                                    color: debate['debateState'] == '토론 중'
                                        ? Colors.purple
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                debate['title'] ?? 'No title',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '승률 ${debate['myArgument'] ?? '정보 없음'} VS ${debate['opponentArgument'] ?? '정보 없음'}',
                              ),
                            ],
                          ),
                          trailing: Image.asset(
                            'assets/images/hotlist.png', // Add your image path here
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tito_app/widgets/reuse/search_bar.dart';
import 'package:tito_app/provider/login_provider.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class ListScreen extends ConsumerStatefulWidget {
  const ListScreen({super.key});

  @override
  ConsumerState<ListScreen> createState() {
    return _ListScreenState();
  }
}

class _ListScreenState extends ConsumerState<ListScreen> {
  final List<String> labels = ['연애', '정치', '연예', '자유', '스포츠'];
  final List<String> statuses = ['전체', '진행중', '투표중', '종료'];
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

  void _fetchDebateList() async {
    final url = Uri.https(
        'pokeeserver-default-rtdb.firebaseio.com', 'debate_list.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> list = data.entries.map((entry) {
        final Map<String, dynamic> debate =
            Map<String, dynamic>.from(entry.value);
        debate['id'] = entry.key; // id 값을 추가합니다.

        return debate;
      }).toList();

      if (selectedSortOption == '최신순') {
        list.sort((a, b) {
          DateTime dateA = DateTime.parse(a['timestamp']);
          DateTime dateB = DateTime.parse(b['timestamp']);
          return dateB.compareTo(dateA); // 내림차순으로 정렬합니다.
        });
      }

      setState(() {
        list = list.where((debate) => debate['visibleDebate'] == true).toList();
        debateList = list;
      });
    } else {
      throw Exception('Failed to load debate list');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginInfo = ref.watch(loginInfoProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('토론 리스트'),
      ),
      body: Column(
        children: [
          CustomSearchBar(),
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
            child: ListView.builder(
              itemCount: debateList.length,
              itemBuilder: (context, index) {
                final debate = debateList[index];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                              debateState == '토론 중') {
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
        ],
      ),
    );
  }
}

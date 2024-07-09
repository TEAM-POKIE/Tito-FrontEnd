import 'package:flutter/material.dart';
import 'package:tito_app/screen/list_screen.dart';
import 'package:tito_app/widgets/mypage/mypage.dart';
import 'package:tito_app/widgets/reuse/bottombar.dart';
import 'package:tito_app/widgets/reuse/search_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tito_app/models/list_info.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

void _goMyPage(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (ctx) => const Mypage(),
    ),
  );
}

void _golistPage(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (ctx) => const ListScreen(),
    ),
  );
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _controller = PageController();

  final List<ListBanner> _bannerItems = [];
  final List<HotList> _hotItems = [];
  var titles = [];
  var contents = [];
  var hotTitles = [];
  var hotContents = [];
  var hotScores = [];

  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchTitles();
    hotList();
  }

  void fetchTitles() async {
    try {
      final url = Uri.https(
          'tito-f8791-default-rtdb.firebaseio.com', 'live_debate_list.json');
      final response = await http.get(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to load data');
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      final List<ListBanner> loadedItems = [];
      for (final item in listData.entries) {
        loadedItems.add(
          ListBanner(
            id: item.key,
            title: item.value['title'],
            content: item.value['content'],
          ),
        );
      }

      setState(() {
        _bannerItems.addAll(loadedItems);
        titles = loadedItems.map((item) => item.title).toList();
        contents = loadedItems.map((item) => item.content).toList();
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurred: $error'),
        ),
      );
    }
  }

  void hotList() async {
    try {
      final hotUrl = Uri.https(
          'tito-f8791-default-rtdb.firebaseio.com', 'hot_debate_list.json');
      final response = await http.get(hotUrl);
      if (response.statusCode != 200) {
        throw Exception('Failed to load data');
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      final List<HotList> hotItems = [];
      for (final item in listData.entries) {
        hotItems.add(
          HotList(
            id: item.key,
            hotTitle: item.value['title'],
            hotContent: item.value['content'],
            hotScore: item.value['hot_count'],
          ),
        );
      }

      setState(() {
        _hotItems.addAll(hotItems);
        hotTitles = hotItems.map((item) => item.hotTitle).toList();
        hotContents = hotItems.map((item) => item.hotContent).toList();
        hotScores = hotItems.map((item) => item.hotScore).toList();
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurred: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0), // AppBar 높이를 조정
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/logo.png', // 로고 이미지 경로
              fit: BoxFit.contain,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Image.asset('assets/images/notification.png'),
            ),
            IconButton(
              onPressed: () {
                _goMyPage(context);
              },
              icon: Image.asset('assets/images/mypage.png'),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 180, // PageView의 높이를 조정
                              child: PageView.builder(
                                controller: _controller,
                                itemCount: titles.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30.0, vertical: 10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'HOT 한 토론🔥',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10,
                                                                vertical: 5),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.purple,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: const Text(
                                                          '실시간 토론중',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  LayoutBuilder(
                                                    builder:
                                                        (context, constraints) {
                                                      return Container(
                                                        width: constraints
                                                                .maxWidth *
                                                            0.8,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              titles[index],
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                              ),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            Text(
                                                              contents[index],
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
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
                            SmoothPageIndicator(
                              controller: _controller,
                              count: titles.length,
                              effect: const WormEffect(
                                dotWidth: 10.0,
                                dotHeight: 10.0,
                                activeDotColor: Colors.black,
                                dotColor: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'HOT한 토론',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    _golistPage(context);
                                  },
                                  child: const Text('더보기 >'))
                            ],
                          ),
                        ),
                        Column(
                          children: List.generate(_hotItems.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: Image.asset(
                                    'assets/images/hotlist.png', // Add your image path here
                                    width: 40,
                                    height: 40,
                                  ),
                                  title: Text(
                                    hotTitles[index],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(hotContents[index]),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.whatshot,
                                        color: Colors.purple,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        hotScores[index].toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}

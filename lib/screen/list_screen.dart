import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:tito_app/models/list_info.dart';
import 'dart:convert';

import 'package:tito_app/widgets/reuse/bottombar.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() {
    return _ListScreenState();
  }
}

class _ListScreenState extends State<ListScreen> {
  final PageController _controller = PageController();

  final List<ListBanner> _bannerItems = [];
  var titles = [];
  var contents = [];

  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchTitles();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('토론 리스트'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Column(
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
                                                      color: Colors.white),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.purple,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: const Text(
                                                    '실시간 토론중',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            LayoutBuilder(
                                              builder: (context, constraints) {
                                                return Container(
                                                  width: constraints.maxWidth *
                                                      0.8,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        titles[index],
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Text(
                                                        contents[index],
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                ),
                const SizedBox(height: 20),
                const Expanded(
                  child: BottomBar(),
                )
              ],
            ),
    );
  }
}

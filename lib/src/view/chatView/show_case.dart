import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowCase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (context) => ShowCaseScreen(),
    );
  }
}

class ShowCaseScreen extends StatefulWidget {
  @override
  _ShowCaseScreenState createState() => _ShowCaseScreenState();
}

class _ShowCaseScreenState extends State<ShowCaseScreen> {
  final GlobalKey _keyTimer = GlobalKey();
  final GlobalKey _keySuggestion = GlobalKey();
  final GlobalKey _keyMessage = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Future.delayed(Duration(seconds: 1), () {
          ShowCaseWidget.of(context)
              .startShowCase([_keyTimer, _keySuggestion, _keyMessage]);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('외계인 있다? 없다?', style: TextStyle(color: Colors.black)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Showcase(
                  key: _keyTimer,
                  description: '포키님의 반론 타임이에요!',
                  tooltipBackgroundColor: Colors.black,
                  textColor: Colors.white,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '🕑 7:20 남았어요!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '🛎 발언 제안 시간이 카운팅 돼요!',
                          style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Showcase(
                  key: _keySuggestion,
                  description: 'LLM의 작성 코칭!',
                  tooltipBackgroundColor: Colors.purple,
                  textColor: Colors.white,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '지금 작성하신 주장은 주제에서 벗어난 것 같아요. 파미의 역설에 대한 반박글을 한 문장으로 작성하는 것을 추천해요!',
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Showcase(
                  key: _keyMessage,
                  description: '상대 의견 작성 타임이에요!',
                  tooltipBackgroundColor: Colors.grey,
                  textColor: Colors.white,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '외계인 있다? 없다?👽',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '이 넓은 우주에 우리가 유일한 생명체일 리가 없다고 생각해요. 은하만 해도 수백 억 개가 있는데 그중에 지구 같은 조건을 가진 행성이 없을까요?',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '만약에 외계인이 정말 있다면 왜 우리랑 접촉을 안 하겠어요? 파미의 역설이라는 게 있잖아요 그동안 아무런 접촉이 없었다는 건 애초에 없다는 증거 아닐까요?',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            SizedBox(width: 10),
                            Text(
                              '타이밍 벨',
                              style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          '상대 의견 작성 타임이에요!',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
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
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset('assets/icons/plus.svg'),
                ),
                Expanded(
                  child: TextField(
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: '상대 의견 작성 타임이에요!',
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (value) {},
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset('assets/icons/sendArrow.svg'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

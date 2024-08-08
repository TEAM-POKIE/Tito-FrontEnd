import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:tito_app/core/provider/live_webSocket_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';

class LiveComment extends ConsumerStatefulWidget {
  @override
  _LiveCommentState createState() => _LiveCommentState();
}

class _LiveCommentState extends ConsumerState<LiveComment>
    with TickerProviderStateMixin {
  bool _isExpanded = false;
  List<Map<String, dynamic>> _messages = [];
  late StreamSubscription<Map<String, dynamic>> _subscription;
  List<AnimationController> _animationControllers = [];
  List<Animation<double>> _animations = [];
  List<double> _positions = [];

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _fetchDebateInfo();
      _subscribeToMessages();
    });
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchDebateInfo() async {
    final liveWebSocketService = ref.read(liveWebSocketProvider);
    final loginInfo = ref.watch(loginInfoProvider);
    final debateInfo = ref.read(chatInfoProvider);

    if (loginInfo != null) {
      final message = jsonEncode({
        "command": "ENTER",
        "userId": loginInfo.id,
        "debateId": debateInfo!.id,
      });
      liveWebSocketService.sendMessage(message);
    } else {
      print("Error: Login info or Debate info is null.");
    }
  }

  void _subscribeToMessages() {
    final webSocketService = ref.read(liveWebSocketProvider);
    final loginInfo = ref.watch(loginInfoProvider);

    _subscription = webSocketService.stream.listen((message) {
      if (message.containsKey('content')) {
        if (mounted) {
          setState(() {
            _messages.add(message);
            print(message);
          });
        }
      }
    });
  }

  void _startAnimation() {
    setState(() {
      final startPosition = Random().nextDouble() * 50;

      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800), // 애니메이션 지속 시간
      );

      final animation = Tween<double>(begin: 0, end: 400).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOut,
        ),
      );

      _animationControllers.add(controller);
      _animations.add(animation);
      _positions.add(startPosition);

      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            final index = _animationControllers.indexOf(controller);
            _animationControllers.removeAt(index);
            _animations.removeAt(index);
            _positions.removeAt(index);
          });
        }
      });

      controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginInfo = ref.read(loginInfoProvider);
    return Stack(
      children: [
        Container(
          width: double.infinity,
          child: Column(
            children: [
              GestureDetector(
                onTap: _toggleExpand,
                child: Container(
                  color: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person,
                            color: ColorSystem.purple,
                          ),
                          SizedBox(width: 8),
                          Text('15명 관전중',
                              style: FontSystem.KR14R
                                  .copyWith(color: ColorSystem.purple)),
                        ],
                      ),
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height:
                    _isExpanded ? MediaQuery.of(context).size.height * 0.2 : 0,
                color: Colors.white,
                child: _isExpanded
                    ? ListView.builder(
                        shrinkWrap: true,
                        controller: ScrollController(),
                        itemCount: _messages.length, // 예시를 위해 고정된 수의 항목을 표시합니다.
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '타카',
                                  style: FontSystem.KR16B
                                      .copyWith(color: ColorSystem.grey),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  message['content'] ?? '',
                                  style: FontSystem.KR16B,
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        ),
        ..._animations.asMap().entries.map((entry) {
          final index = entry.key;
          final animation = entry.value;
          final position = _positions[index];

          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Positioned(
                bottom: 70 + animation.value,
                right: position,
                child: Image.asset('assets/images/livefire.png'),
              );
            },
          );
        }).toList(),
        _isExpanded
            ? Positioned(
                bottom: 10,
                right: 10,
                child: FloatingActionButton(
                  onPressed: _startAnimation,
                  shape: const CircleBorder(),
                  child: Image.asset('assets/images/livefire.png'),
                  backgroundColor: Colors.white,
                  elevation: 2,
                ),
              )
            : SizedBox(
                width: 0,
              ),
      ],
    );
  }
}

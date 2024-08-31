import 'dart:async';
import 'dart:convert';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:tito_app/core/provider/live_webSocket_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/voting_provider.dart';

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
  Map<String, dynamic>? _firstMessage; // 첫 번째 메시지를 저장할 변수

  List<double> _positions = [];
  int _messageCounter = 0; // 나중에 지우기
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _messageCounter = 0; // 나중에 지우기
      _fetchDebateInfo();
      _subscribeToMessages();
    });
  }

  Future<void> _fetchDebateInfo() async {
    final liveWebSocketService = ref.read(liveWebSocketProvider);
    final loginInfo = ref.read(loginInfoProvider);
    final debateInfo = ref.read(chatInfoProvider);

    if (loginInfo != null && debateInfo != null) {
      final message = jsonEncode({
        "command": "ENTER",
        "userId": loginInfo.id,
        "debateId": debateInfo.id,
      });
      liveWebSocketService.sendMessage(message);
    } else {
      print("Error: Login info or Debate info is null.");
    }
  }

  void _subscribeToMessages() {
    final webSocketService = ref.read(liveWebSocketProvider);
    final voteViewModel = ref.watch(voteProvider.notifier);
    final chatState = ref.watch(chatInfoProvider);

    _subscription = webSocketService.stream.listen((message) {
      if (chatState!.isVoteEnded) {
        return;
      }
      _messageCounter++; // 새로운 메시지가 들어올 때마다 카운터 증가 나중에 지우면 돼
      if (_messageCounter == 7 ||
          _messageCounter == 8 ||
          _messageCounter == 9 ||
          _messageCounter == 10 ||
          _messageCounter == 11 ||
          _messageCounter == 12 ||
          _messageCounter == 13 ||
          _messageCounter == 14 ||
          _messageCounter == 15 ||
          _messageCounter == 16 ||
          _messageCounter == 17 ||
          _messageCounter == 18 ||
          _messageCounter == 19) {
        return;
      }
      if (message['command'] == "VOTE_RATE_RES") {
        final newBlueVotes = message["ownerVoteRate"];
        final newRedVotes = message["joinerVoteRate"];

        // StateNotifier를 사용하여 상태를 업데이트합니다.
        voteViewModel.updateVotes(newBlueVotes, newRedVotes);
      }
      if (message.containsKey('content')) {
        if (_firstMessage == null) {
          // 첫 번째 메시지 설정
          _firstMessage = message;
          _addMessage(message);
        } else if (_isSameMessage(_firstMessage!, message)) {
          // 첫 번째 메시지와 동일한 메시지가 들어오면 메시지 추가 중단
          chatState.isVoteEnded = true;
        } else {
          // 첫 번째 메시지와 다른 메시지인 경우에만 추가
          _addMessage(message);
        }
      }
    });
  }

  bool _isSameMessage(Map<String, dynamic> first, Map<String, dynamic> second) {
    // 두 메시지의 'content', 'userId', 'createdAt'가 동일한지 확인하여 동일한 메시지인지 판단
    return first['content'] == second['content'] &&
        first['userId'] == second['userId'] &&
        first['createdAt'] == second['createdAt'];
  }

  void _addMessage(Map<String, dynamic> message) {
    if (mounted) {
      setState(() {
        _messages.add(message);
      });
    }
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startAnimation() {
    final chatViewModel = ref.read(chatInfoProvider.notifier);
    chatViewModel.sendFire();
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
                          Text('${_messages.length}명 관전중',
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
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                height: _isExpanded
                    ? MediaQuery.of(context).size.height * 0.2
                    : 0.0,
                color: Colors.white,
                child: _isExpanded
                    ? ListView.builder(
                        shrinkWrap: true,
                        controller: ScrollController(),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    message['userImgUrl'],
                                  ),
                                  radius: 12.r,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  message['userNickName'] ?? '',
                                  style: FontSystem.KR14R
                                      .copyWith(color: ColorSystem.grey1),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    message['content'] ?? '',
                                    style: FontSystem.KR14M,
                                    maxLines: null,
                                    overflow: TextOverflow.visible,
                                  ),
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

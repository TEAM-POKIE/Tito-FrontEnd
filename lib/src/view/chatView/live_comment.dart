import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  StreamSubscription<Map<String, dynamic>>? _subscription;
  List<AnimationController> _animationControllers = [];
  List<Animation<double>> _animations = [];
  List<double> _positions = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _subscribeToMessages();
    });
  }

  void _subscribeToMessages() {
    final webSocketService = ref.read(liveWebSocketProvider);

    _subscription = webSocketService.stream.listen((message) {
      if (message.containsKey('content')) {
        print('good? ${message}');
        _addMessage(message);
      }
    });
  }

  void _addMessage(Map<String, dynamic> message) {
    setState(() {
      _messages.add(message);
    });
    // bool isDuplicate = _messages.any((existingMessage) =>
    //     existingMessage['content'] == message['content'] &&
    //     existingMessage['createdAt'] == message['createdAt']);

    // if (!isDuplicate && mounted) {

    // }
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  void dispose() {
    // WebSocket 구독 해제
    _subscription?.cancel();
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startAnimation() {
    final chatViewModel = ref.read(chatInfoProvider.notifier);
    chatViewModel.sendFire();

    if (mounted) {
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
          if (status == AnimationStatus.completed && mounted) {
            setState(() {
              final index = _animationControllers.indexOf(controller);
              if (index != -1) {
                _animationControllers.removeAt(index);
                _animations.removeAt(index);
                _positions.removeAt(index);
              }
            });
          }
        });

        controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          const Icon(
                            Icons.person,
                            color: ColorSystem.purple,
                          ),
                          const SizedBox(width: 8),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: message['userImageUrl'] !=
                                              null &&
                                          message['userImageUrl']!.isNotEmpty
                                      ? NetworkImage(message['userImageUrl']!)
                                      : null,
                                  radius: 20.r,
                                  child: message['userImageUrl'] == null ||
                                          message['userImageUrl']!.isEmpty
                                      ? SvgPicture.asset(
                                          'assets/icons/basicProfile.svg')
                                      : null,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  message['userNickName'] ?? '',
                                  style: FontSystem.KR14R
                                      .copyWith(color: ColorSystem.grey1),
                                ),
                                const SizedBox(width: 10),
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
                    : const SizedBox.shrink(),
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
            : const SizedBox(width: 0),
      ],
    );
  }
}

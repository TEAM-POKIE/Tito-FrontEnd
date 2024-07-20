import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/live_comment.dart';
import 'package:tito_app/src/view/chatView/live_send_view.dart';
import 'package:tito_app/src/viewModel/live_comment_viewModel.dart';

class LiveComment extends ConsumerStatefulWidget {
  final String username;
  final String id;
  final ScrollController scrollController;

  const LiveComment({
    super.key,
    required this.username,
    required this.id,
    required this.scrollController,
  });

  @override
  _LiveCommentState createState() => _LiveCommentState();
}

class _LiveCommentState extends ConsumerState<LiveComment>
    with TickerProviderStateMixin {
  late Future<List<Message>> _initialMessagesFuture;
  List<Message> _messages = [];
  List<AnimationController> _animationControllers = [];
  List<Animation<double>> _animations = [];
  List<double> _positions = [];

  @override
  void initState() {
    super.initState();
    final liveCommentViewModel =
        ref.read(liveCommentProvider(widget.id).notifier);
    _initialMessagesFuture = liveCommentViewModel.loadInitialMessages();
    _initialMessagesFuture.then((messages) {
      if (mounted) {
        setState(() {
          _messages = messages;
        });
      }
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
    final liveCommentViewModel =
        ref.watch(liveCommentProvider(widget.id).notifier);

    return FutureBuilder<List<Message>>(
      future: _initialMessagesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading messages'));
        }

        if (snapshot.hasData) {
          _messages = snapshot.data!;
        }

        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<Message>>(
                    stream: liveCommentViewModel.messagesStream,
                    builder: (context, streamSnapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('메시지를 불러오는 중 오류가 발생했습니다.'));
                      }

                      if (streamSnapshot.hasData) {
                        final newMessages = streamSnapshot.data!;
                        final messageIds = _messages.map((m) => m.id).toSet();
                        final nonDuplicateMessages = newMessages
                            .where((m) => !messageIds.contains(m.id))
                            .toList();
                        _messages = [
                          ..._messages,
                          ...nonDuplicateMessages,
                        ];
                        _messages
                            .sort((a, b) => a.createdAt.compareTo(b.createdAt));
                      }

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (widget.scrollController.hasClients) {
                          widget.scrollController.jumpTo(
                              widget.scrollController.position.maxScrollExtent);
                        }
                      });

                      return ListView.builder(
                        controller: widget.scrollController,
                        reverse: true,
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                  child: Text(
                                    message.username[0].toUpperCase(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      message.username,
                                      style: FontSystem.KR12B
                                          .copyWith(color: ColorSystem.grey),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      message.message,
                                      style: FontSystem.KR12B,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                LiveSendView(username: widget.username, roomId: widget.id),
              ],
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
            Positioned(
              bottom: 70,
              right: 10,
              child: FloatingActionButton(
                onPressed: _startAnimation,
                shape: const CircleBorder(), // 동그란 버튼을 위해 CircleBorder 사용
                child:
                    Image.asset('assets/images/livefire.png'), // 불 아이콘 이미지 경로
                backgroundColor: Colors.white,
                elevation: 2,
              ),
            ),
          ],
        );
      },
    );
  }
}

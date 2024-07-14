import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:grouped_list/grouped_list.dart';
import 'package:tito_app/src/widgets/reuse/debate_popup.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:speech_balloon/speech_balloon.dart';

class Chat extends ConsumerStatefulWidget {
  final String id; // 채팅방 고유 ID

  const Chat({
    super.key,
    required this.id,
  });

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends ConsumerState<Chat> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late WebSocketChannel _channel;
  List<types.Message> _messages = [];
  bool _isFirstMessage = true;

  String fadeText = '첫 채팅을 입력해주세요!';
  Map<String, dynamic>? debateData;

  @override
  void initState() {
    super.initState();
    _channel = WebSocketChannel.connect(Uri.parse('ws://localhost:4040/ws'));
    _channel.stream.listen(_onReceiveMessage);
    _fetchDebateData();
    _fetchMessages();
    debateData;
  }

  Future<bool> showDebatePopup(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return DebatePopup(
          debateId: widget.id,
          nick: ref.read(loginInfoProvider)!.nickname,
          onUpdate: (opponentNick) {
            setState(() {
              debateData?['opponentNick'] = opponentNick;
            });
          },
        );
      },
    );

    return result ?? false; // return false if result is null
  }

  @override
  void dispose() {
    _channel.sink.close(status.goingAway);
    super.dispose();
  }

  void _onReceiveMessage(dynamic message) {
    final decodedMessage = json.decode(message);
    final chatMessage = types.TextMessage(
      author: types.User(id: decodedMessage['senderId'] ?? ''),
      createdAt:
          DateTime.parse(decodedMessage['timestamp']).millisecondsSinceEpoch,
      id: decodedMessage['id'] ?? '',
      text: decodedMessage['text'] ?? '',
    );

    setState(() {
      _messages.insert(0, chatMessage);
    });
  }

  Future<void> _fetchMessages() async {
    final url = Uri.https('pokeeserver-default-rtdb.firebaseio.com',
        'chat_list/${widget.id}.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>?;
      final loadedMessages = <types.Message>[];

      if (data != null) {
        data.forEach((key, value) {
          loadedMessages.add(types.TextMessage(
            author: types.User(id: value['senderId'] ?? ''),
            createdAt:
                DateTime.parse(value['timestamp'] ?? '').millisecondsSinceEpoch,
            id: key,
            text: value['text'] ?? '',
          ));
        });
      }

      setState(() {
        _messages = loadedMessages.toList(); // 오래된 메시지가 위로 가도록 순서를 뒤집어 설정
      });
    } else {
      print('Failed to load messages');
    }
  }

  Future<void> _fetchDebateData() async {
    final url = Uri.https('pokeeserver-default-rtdb.firebaseio.com',
        'debate_list/${widget.id}.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        debateData = json.decode(response.body);
      });
    } else {
      print('Failed to load debate data');
    }
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) {
      return;
    }
    final url = Uri.https('pokeeserver-default-rtdb.firebaseio.com',
        'debate_list/${widget.id}.json');
    final loginInfo = ref.read(loginInfoProvider);

    final newMessage = {
      'text': _controller.text.trim(),
      'timestamp': DateTime.now().toIso8601String(),
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
    };
    await http.patch(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'turnId': loginInfo!.nickname}));

    setState(() {
      debateData?.addAll({'turnId': loginInfo.nickname});
    });

    _controller.clear();
    _channel.sink.add(json.encode(newMessage));

    if (_isFirstMessage) {
      fadeText = '첫 채팅 작성을 완료했습니다!\n 토론 참여자를 기다려보세요 !';

      final updateData = {
        'visibleDebate': true,
      };

      final response = await http.patch(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(updateData));

      if (response.statusCode == 200) {
        _isFirstMessage = false;
        setState(() {
          debateData?.addAll(updateData);
        });
        print('Debate room created successfully.');
      } else {
        print('Failed to create debate room: ${response.body}');
      }
    }

    setState(() {
      _messages.add(types.TextMessage(
        author: types.User(id: loginInfo.nickname),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: newMessage['id'] ?? '',
        text: newMessage['text'] ?? '',
      ));
    });

    final chatUrl = Uri.https('pokeeserver-default-rtdb.firebaseio.com',
        'chat_list/${widget.id}.json');
    await http.post(chatUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'senderId': loginInfo.nickname,
          'text': newMessage['text'] ?? '',
          'timestamp': newMessage['timestamp'],
        }));
  }

  void _back() {
    if (_isFirstMessage) {
      context.pop();
    } else {
      context.go('/list');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginInfo = ref.read(loginInfoProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: debateData != null
            ? Text(debateData!['title'] ?? 'No Title')
            : Text('Loading...'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: _back,
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/images/info.png'),
            onPressed: () {
              // 추가 작업
            },
          ),
        ],
      ),
      body: debateData != null
          ? Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/images/chatprofile.png'),
                          const SizedBox(width: 8),
                          Text(
                            debateData!['myNick'],
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            ':',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            debateData!['myArgument'] ?? '',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Image.asset('assets/images/chatprofile.png'),
                          const SizedBox(width: 8),
                          Text(
                            debateData!['opponentNick'] != ''
                                ? debateData!['opponentNick']
                                : '당신의 의견',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            ':',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            debateData!['opponentArgument'] ?? '',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GroupedListView<types.Message, DateTime>(
                    elements: _messages,
                    groupBy: (message) => DateTime(
                      DateTime.fromMillisecondsSinceEpoch(message.createdAt!)
                          .year,
                      DateTime.fromMillisecondsSinceEpoch(message.createdAt!)
                          .month,
                      DateTime.fromMillisecondsSinceEpoch(message.createdAt!)
                          .day,
                    ),
                    groupHeaderBuilder: (types.Message message) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${DateTime.fromMillisecondsSinceEpoch(message.createdAt!).year}-${DateTime.fromMillisecondsSinceEpoch(message.createdAt!).month}-${DateTime.fromMillisecondsSinceEpoch(message.createdAt!).day}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    itemBuilder: (context, types.Message message) {
                      final isMyMessage =
                          message.author.id == loginInfo!.nickname;
                      final formattedTime = TimeOfDay.fromDateTime(
                              DateTime.fromMillisecondsSinceEpoch(
                                  message.createdAt!))
                          .format(context);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: isMyMessage
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            if (!isMyMessage)
                              const CircleAvatar(child: Icon(Icons.person)),
                            if (!isMyMessage) const SizedBox(width: 8),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 250),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text((message as types.TextMessage).text),
                                  const SizedBox(height: 5),
                                  Text(
                                    formattedTime,
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                            if (isMyMessage) const SizedBox(width: 8),
                          ],
                        ),
                      );
                    },
                    useStickyGroupSeparators: true,
                    floatingHeader: true,
                    order: GroupedListOrder.ASC,
                  ),
                ),
                debateData!['myNick'] == loginInfo!.nickname
                    ? Padding(
                        padding: const EdgeInsets.all(10),
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff8E48F8),
                          ),
                          child: AnimatedTextKit(
                            repeatForever: true,
                            animatedTexts: [
                              FadeAnimatedText(fadeText),
                            ],
                          ),
                        ),
                      )
                    : const SpeechBalloon(
                        width: 260,
                        height: 70,
                        borderRadius: 12,
                        nipLocation: NipLocation.bottom,
                        color: Color(0xff8E48F8),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 10),
                          child: Text(
                            '토론 참여자를 기다리고 있어요! 의견을 작성해보세요 !',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          autocorrect: false,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            hintText: '상대 의견 작성 타임이에요!',
                            fillColor: Colors.grey[200],
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSubmitted: (value) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () async {
                          if (debateData?['opponentNick'] == '' &&
                              debateData?['myNick'] != loginInfo.nickname) {
                            final popupResult = await showDebatePopup(context);
                            if (popupResult) {
                              await _sendMessage();
                            }
                          } else if (debateData!['turnId'] !=
                              loginInfo!.nickname) {
                            _sendMessage();
                          }
                        },
                        icon: Image.asset('assets/images/sendArrow.png'),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/provider/debate_provider.dart';
import 'package:tito_app/provider/login_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:grouped_list/grouped_list.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Chat extends ConsumerStatefulWidget {
  final String myId;
  final String opponentId;
  final String id;
  final String title;

  const Chat({
    super.key,
    required this.id,
    required this.myId,
    required this.opponentId,
    required this.title,
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

  @override
  void initState() {
    super.initState();
    _channel = WebSocketChannel.connect(Uri.parse('ws://localhost:4040/ws'));
    _channel.stream.listen(_onReceiveMessage);
    _fetchMessages();
    _requestFocus();
  }

  @override
  void dispose() {
    _channel.sink.close(status.goingAway);
    super.dispose();
  }

  void _onReceiveMessage(dynamic message) {
    final decodedMessage = json.decode(message);
    final types.Message chatMessage = types.TextMessage(
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
      final Map<String, dynamic>? data = json.decode(response.body);
      final List<types.Message> loadedMessages = [];

      if (data != null) {
        data.forEach((key, value) {
          loadedMessages.add(types.TextMessage(
            author: types.User(id: value['senderId'] ?? ''),
            createdAt:
                DateTime.parse(value['timestamp'] ?? '').millisecondsSinceEpoch,
            id: key ?? '',
            text: value['text'] ?? '',
          ));
        });
      }

      setState(() {
        // 오래된 메시지가 위로 가도록 순서를 뒤집어 설정
        _messages = loadedMessages.reversed.toList();
      });
    } else {
      // 에러 처리
      print('Failed to load messages');
    }
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) {
      return;
    }
    final loginInfo = ref.read(loginInfoProvider);
    final debateInfo = ref.read(debateInfoProvider);
    final newMessage = {
      'text': _controller.text.trim(),
      'AId': widget.myId,
      'BId': widget.opponentId,
      'timestamp': DateTime.now().toIso8601String(),
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    _channel.sink.add(json.encode(newMessage));

    if (_isFirstMessage) {
      // 토론방 생성
      final url = Uri.https(
          'pokeeserver-default-rtdb.firebaseio.com', 'debate_list.json');
      final currentTime = DateTime.now().toIso8601String();

      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'title': debateInfo?.title ?? '',
            'category': debateInfo?.category ?? '',
            'myArgument': debateInfo?.myArgument ?? '',
            'myId': loginInfo?.email ?? '',
            'opponentArgument': debateInfo?.opponentArgument ?? '',
            'opponentId': debateInfo?.opponentId ?? '',
            'debateState': debateInfo?.debateState ?? '',
            'timestamp': currentTime,
          }));

      if (response.statusCode == 200) {
        _isFirstMessage = false;
        print('Debate room created successfully.');
      } else {
        // 에러 처리
        print('Failed to create debate room: ${response.body}');
      }
    }

    setState(() {
      _messages.add(
        types.TextMessage(
          author: types.User(id: widget.myId),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: newMessage['id'] ?? '', // 기본값 설정
          text: newMessage['text'] ?? '', // 기본값 설정
        ),
      );
    });

    // 메시지를 Firebase에 저장
    final url = Uri.https('pokeeserver-default-rtdb.firebaseio.com',
        'chat_list/${widget.id}.json');
    await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'senderId': loginInfo?.email ?? '',
          'text': newMessage['text'] ?? '',
          'timestamp': newMessage['timestamp'],
        }));

    _controller.clear();
    _focusNode.requestFocus(); // 메시지를 보낸 후에도 키보드가 열리도록 유지
  }

  void _requestFocus() {
    Future.delayed(const Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginInfo = ref.read(loginInfoProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // 추가 작업
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                color: const Color(0xffE5E5E5),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.chat_bubble_outline, color: Colors.black),
                        SizedBox(width: 8),
                        Text(
                          '상대의 의견을 반박하며 토론을 시작해보세요!',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.hourglass_bottom, color: Colors.brown),
                        SizedBox(width: 8),
                        Text(
                          '7:20 남았어요!',
                          style:
                              TextStyle(color: Color(0xff8E48F8), fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: GroupedListView<types.Message, DateTime>(
                  elements: _messages,
                  groupBy: (message) => DateTime(
                    DateTime.fromMillisecondsSinceEpoch(message.createdAt!)
                        .year,
                    DateTime.fromMillisecondsSinceEpoch(message.createdAt!)
                        .month,
                    DateTime.fromMillisecondsSinceEpoch(message.createdAt!).day,
                  ),
                  groupHeaderBuilder: (types.Message message) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        '${DateTime.fromMillisecondsSinceEpoch(message.createdAt!).year}-${DateTime.fromMillisecondsSinceEpoch(message.createdAt!).month}-${DateTime.fromMillisecondsSinceEpoch(message.createdAt!).day}',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                  itemBuilder: (context, types.Message message) {
                    final isMyMessage = message.author.id == loginInfo?.email;
                    final formattedTime = TimeOfDay.fromDateTime(
                            DateTime.fromMillisecondsSinceEpoch(
                                message.createdAt!))
                        .format(context)
                        .toString();

                    return Align(
                      alignment: isMyMessage
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: isMyMessage
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            if (!isMyMessage)
                              CircleAvatar(child: Icon(Icons.person)),
                            if (!isMyMessage) const SizedBox(width: 8),
                            Container(
                              constraints: BoxConstraints(maxWidth: 250),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: isMyMessage
                                    ? Colors.blue[100]
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text((message as types.TextMessage).text),
                                  SizedBox(height: 5),
                                  Text(
                                    formattedTime,
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                            if (isMyMessage) const SizedBox(width: 8),
                            if (isMyMessage)
                              CircleAvatar(child: Icon(Icons.person)),
                          ],
                        ),
                      ),
                    );
                  },
                  useStickyGroupSeparators: true,
                  floatingHeader: true,
                  order: GroupedListOrder.ASC,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
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
                      onPressed: _sendMessage,
                      icon: Image.asset('assets/images/sendArrow.png'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

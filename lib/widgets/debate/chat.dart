import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tito_app/provider/login_provider.dart';
import 'dart:async';

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
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];
  Timer? _timer;
  String? _currentDate;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _requestFocus();
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _fetchMessages();
    });
  }

  Future<void> _fetchMessages() async {
    final url = Uri.https('tito-f8791-default-rtdb.firebaseio.com',
        'chat_list/${widget.id}.json');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = json.decode(response.body);
      final List<Map<String, dynamic>> loadedMessages = [];

      if (data != null) {
        data.forEach((key, value) {
          loadedMessages.add({
            'text': value['text'] ?? '',
            'senderId': value['senderId'] ?? '',
            'timestamp': value['timestamp'] ?? '',
          });
        });
      }

      setState(() {
        _messages = loadedMessages;
        if (_messages.isNotEmpty) {
          final DateTime messageTime =
              DateTime.parse(_messages.first['timestamp'] ?? '');
          _currentDate =
              '${messageTime.year}-${messageTime.month}-${messageTime.day}';
          _scrollToBottom();
        }
      });
    } else {
      // 에러 처리
      print('Failed to load messages');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _sendMessage() async {
    final loginInfo = ref.watch(loginInfoProvider);
    if (_controller.text.trim().isEmpty) {
      return;
    }

    final newMessage = {
      'text': _controller.text.trim(),
      'senderId': loginInfo?.email ?? '',
      'aId': widget.myId,
      'bId': widget.opponentId,
      'timestamp': DateTime.now().toIso8601String(),
    };

    final url = Uri.https('tito-f8791-default-rtdb.firebaseio.com',
        'chat_list/${widget.id}.json');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newMessage),
    );

    if (response.statusCode == 200) {
      setState(() {
        _messages.add(newMessage);
        _controller.clear();
        _focusNode.requestFocus(); // 메시지를 보낸 후에도 키보드가 열리도록 유지

        // 날짜 업데이트
        final DateTime messageTime = DateTime.parse(
            newMessage['timestamp'] ?? DateTime.now().toIso8601String());
        _currentDate =
            '${messageTime.year}-${messageTime.month}-${messageTime.day}';
        _scrollToBottom();
      });
    }
  }

  void _requestFocus() {
    Future.delayed(Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.chat_bubble_outline,
                            color: Colors.black),
                        const SizedBox(width: 8),
                        const Text(
                          '상대의 의견을 반박하며 토론을 시작해보세요!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.hourglass_bottom, color: Colors.brown),
                        const SizedBox(width: 8),
                        Text(
                          '7:20 남았어요!',
                          style: TextStyle(
                            color: const Color(0xff8E48F8),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _messages.length + 1, // 메시지 개수 + 1 (날짜)
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // 날짜를 첫 번째 아이템으로 표시
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            _currentDate ?? '',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      );
                    }

                    final message = _messages[index - 1]; // 메시지 인덱스는 1부터 시작
                    final isMyMessage = message['senderId'] == widget.myId;
                    final messageTime = DateTime.parse(message['timestamp'] ??
                        DateTime.now().toIso8601String());
                    final formattedTime = TimeOfDay.fromDateTime(messageTime)
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
                              CircleAvatar(
                                child: Icon(Icons.person),
                              ),
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
                                  Text(message['text']),
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
                              CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode, // 포커스 노드를 텍스트 필드에 연결
                        decoration: InputDecoration(
                          hintText: '상대 의견 작성 타임이에요!',
                          fillColor: Colors.grey[200],
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (value) =>
                            _sendMessage(), // 엔터키를 누르면 메시지를 보냄
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
          Positioned(
            right: 16.0,
            bottom: 80.0,
            child: Container(
              alignment: Alignment.bottomRight,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/timingBell.png'),
                    const Text(
                      '타이밍 벨',
                      style: TextStyle(color: Color(0xffDCF333)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

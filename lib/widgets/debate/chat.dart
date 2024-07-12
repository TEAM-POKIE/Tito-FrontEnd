import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Chat extends StatefulWidget {
  final String myId;
  final String opponentId;
  final String id;

  const Chat(
      {super.key,
      required this.id,
      required this.myId,
      required this.opponentId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _requestFocus();
  }

  Future<void> _fetchMessages() async {
    final url =
        Uri.https('tito-f8791-default-rtdb.firebaseio.com', 'chat_list.json');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _messages = List<Map<String, dynamic>>.from(json.decode(response.body));
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

    final newMessage = {
      'text': _controller.text.trim(),
      'aId': widget.myId,
      'brId': widget.opponentId,
      'timestamp': DateTime.now().toIso8601String(),
    };

    final url =
        Uri.https('tito-f8791-default-rtdb.firebaseio.com', 'chat_list.json');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newMessage),
    );

    if (response.statusCode == 200) {
      setState(() {
        _messages.insert(0, newMessage);
        _controller.clear();
        _focusNode.requestFocus(); // 메시지를 보낸 후에도 키보드가 열리도록 유지
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
        title: const Text('외계인 있다? 없다?'),
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
              const Center(
                child: Text(
                  '2024년 6월 15일',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final isMyMessage = message['senderId'] == widget.myId;
                    final messageTime = DateTime.parse(message['timestamp']);
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

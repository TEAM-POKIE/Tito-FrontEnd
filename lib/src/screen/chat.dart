import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_state_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/src/data/models/debate_info.dart';
import 'package:tito_app/src/data/models/login_info.dart';
import 'package:tito_app/src/view/chatView/chat_appBar.dart';
import 'package:tito_app/src/view/chatView/chat_body.dart';
import 'package:tito_app/src/view/chatView/live_comment.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

class Chat extends ConsumerStatefulWidget {
  final int turn = 0;

  const Chat({
    super.key,
  });

  @override
  ConsumerState<Chat> createState() => _ChatState();
}

class _ChatState extends ConsumerState<Chat> {
  late WebSocketChannel channel;
  late String myNick;

  // @override
  // void initState() {
  //   super.initState();
  //   // WebSocket 서버와 연결 설정
  //   channel = WebSocketChannel.connect(Uri.parse('ws://192.168.1.6:4040/ws'));

  //   // WebSocket 서버로부터 메시지를 받을 때마다 상태 업데이트
  //   channel.stream.listen((message) {
  //     final data = json.decode(message);
  //     if (data['type'] == 'update_myNick') {
  //       setState(() {
  //         myNick = data['myNick'];
  //       });
  //     }
  //   });

  //   // 초기 데이터를 가져오는 HTTP 요청
  //   _fetchInitialData();
  // }

  // Future<void> _fetchInitialData() async {
  //   final apiService = ApiService(DioClient.dio);
  //   final data = await apiService.getData('debate_list/');
  //   if (data != null && data.containsKey('myNick')) {
  //     setState(() {
  //       myNick = data['myNick'];
  //     });
  //   }
  // }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProviders);
    final loginInfo = ref.watch(loginInfoProvider);

    // if (loginInfo == null || chatState.debateData == null) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    return _BasicDebate(
      chatState: chatState,
    );
    // } else {
    //   return _LiveComment(
    //     loginInfo: loginInfo,
    //     chatState: chatState,
    //   );
    // }
  }
}

class _BasicDebate extends StatelessWidget {
  final ChatState chatState;

  const _BasicDebate({
    required this.chatState,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: ChatAppbar(), // id 전달
      ),
      body: ChatBody(),
    );
  }
}

// class _LiveComment extends StatefulWidget {
//   final LoginInfo loginInfo;
//   final ChatState chatState;

//   final PanelController _panelController = PanelController();

//   _LiveComment({
//     required this.loginInfo,
//     required this.chatState,
//   });

//   @override
//   State<_LiveComment> createState() => _LiveCommentState();
// }

// class _LiveCommentState extends State<_LiveComment> {
//   bool xIcon = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(80.0),
//         child: ChatAppbar(), // id 전달
//       ),
//       body: SlidingUpPanel(
//         onPanelSlide: (position) {
//           setState(() {
//             xIcon = position > 0.3;
//           });
//         },

//         header: Container(
//           decoration: const BoxDecoration(
//             border: Border(
//               bottom: BorderSide(color: ColorSystem.grey, width: 1.0),
//             ),
//           ),
//           width: MediaQuery.of(context).size.width,
//           alignment: Alignment.center,
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               xIcon
//                   ? const SizedBox(
//                       width: 40,
//                     )
//                   : const SizedBox(
//                       width: 0,
//                     ),
//               const Text(
//                 '방청객 실시간 댓글',
//                 style: FontSystem.KR20B,
//                 textAlign: TextAlign.center,
//               ),
//               xIcon
//                   ? IconButton(
//                       icon: const Icon(
//                         Icons.close,
//                         color: Colors.grey,
//                       ),
//                       onPressed: () {
//                         widget._panelController.close();
//                       },
//                     )
//                   : const SizedBox(width: 0),
//             ],
//           ),
//         ),
//         controller: widget._panelController,
//         panelBuilder: (scrollController) => Container(
//           margin: const EdgeInsets.only(top: 70.0), // 상단 마진 추가
//           child: LiveComment(
//             username: widget.loginInfo.nickname,
//             scrollController: scrollController,
//           ),
//         ),
//         body: GestureDetector(
//           child: ChatBody(),
//         ),
//         backdropEnabled: true,
//         backdropOpacity: 0.5,
//         minHeight: 40, // 패널의 최소 높이 설정
//         maxHeight: MediaQuery.of(context).size.height * 0.5, // 패널의 최대 높이 설정
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(24.0),
//           topRight: Radius.circular(24.0),
//         ),
//         isDraggable: true,
//       ),
//     );
//   }
// }

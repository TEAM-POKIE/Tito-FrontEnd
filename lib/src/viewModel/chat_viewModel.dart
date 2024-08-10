import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';

import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:tito_app/core/provider/userProfile_provider.dart';

import 'package:tito_app/src/data/models/debate_info.dart';

import 'package:tito_app/src/viewModel/timer_viewModel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class ChatViewModel extends StateNotifier<DebateInfo?> {
  final Ref ref;
  TimerNotifier? timerNotifier;

  ChatViewModel(this.ref) : super(null) {
    _connectWebSocket();
  }

  late WebSocketChannel _channel;
  late WebSocketChannel _liveChannel;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final List<Map<String, dynamic>> _messages = [];

  List<Map<String, dynamic>> get messages => _messages;

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  // Debate 정보를 가져오는 메소드
  Future<void> fetchDebateInfo(int id) async {
    try {
      final debateInfo = await ApiService(DioClient.dio).getDebateInfo(id);

      state = debateInfo;
    } catch (error) {
      print('Error fetching debate info: $error');
      state = null;
    }
  }

  void _connectWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://dev-tito.owsla.duckdns.org/ws/debate'),
    );
    _channel.stream.listen((message) {
      if (message is String && message.startsWith('{')) {
        final decodedMessage = json.decode(message) as Map<String, dynamic>;
        _messages.add(decodedMessage);
        _messageController.sink.add(decodedMessage);
      } else {
        print('Invalid message format or non-JSON string received: $message');
      }
    }, onError: (error) {
      print('WebSocket error: $error');
    }, onDone: () {
      print('WebSocket connection closed');
    });
    _liveChannel = WebSocketChannel.connect(
      Uri.parse('wss://dev-tito.owsla.duckdns.org/ws/debate/realtime'),
    );
    _liveChannel.stream.listen((message) {
      if (message is String && message.startsWith('{')) {
        final decodedMessage = json.decode(message) as Map<String, dynamic>;
        _messages.add(decodedMessage);
        _messageController.sink.add(decodedMessage);
      } else {
        print('Invalid message format or non-JSON string received: $message');
      }
    }, onError: (error) {
      print('WebSocket error: $error');
    }, onDone: () {
      print('WebSocket connection closed');
    });
  }

  void sendMessage() {
    final loginInfo = ref.read(loginInfoProvider);

    final message = controller.text;

    if (message.isEmpty) return;

    final jsonMessage = json.encode({
      "command": "CHAT",
      "userId": loginInfo?.id ?? '',
      "debateId": state?.id ?? 0,
      "content": message
    });
    print(jsonMessage);

    _channel.sink.add(jsonMessage);
    controller.clear();
    focusNode.requestFocus();
    // Reset the timer to 8 minutes
  }

  void sendChatMessage() {
    final loginInfo = ref.read(loginInfoProvider);

    final message = controller.text;

    if (message.isEmpty) return;

    final jsonMessage = json.encode({
      "command": "CHAT",
      "userId": loginInfo?.id ?? '',
      "debateId": state?.id ?? 0,
      "userNickName": loginInfo!.nickname,
      "userImgUrl":
          'https://dev-tito.owsla.duckdns.org/images/20240808/afbf7130-312d-46e7-972b-69dcb1b0b5e8.png',
      "content": message,
    });
    print(jsonMessage);

    _liveChannel.sink.add(jsonMessage);
    controller.clear();
    focusNode.requestFocus();
    // Reset the timer to 8 minutes
  }

  void sendFire() {
    final jsonMessage = json.encode({
      "command": "FIRE",
      "debateId": state?.id ?? 0,
    });
    print(jsonMessage);

    _liveChannel.sink.add(jsonMessage);
    controller.clear();
    focusNode.requestFocus();
    // Reset the timer to 8 minutes
  }

  void getProfile(
    id,
    context,
  ) async {
    final userInfo = await ApiService(DioClient.dio).getUserProfile(id);
    final popupViewModel = ref.read(popupProvider.notifier);
    final userProfileViewModel = ref.read(userProfileProvider.notifier);

    userProfileViewModel.setUserInfo(userInfo);

    popupViewModel.showTitlePopup(context);
  }

  void getInfo(
    id,
    context,
  ) async {
    final userInfo = await ApiService(DioClient.dio).getUserProfile(id);
    final userProfileViewModel = ref.read(userProfileProvider.notifier);

    userProfileViewModel.setUserInfo(userInfo);
    if (id == state!.debateOwnerId) {
      state!.debateOwnerNick = userInfo.nickname;
    } else if (id == state!.debateJoinerId) {
      state!.debateJoinerNick = userInfo.nickname;
    }
  }

  void timingSend() {
    final loginInfo = ref.read(loginInfoProvider);
    final jsonMessage = json.encode({
      "command": "TIMING_BELL_REQ",
      "userId": loginInfo?.id ?? '',
      "debateId": state?.id ?? 0,
    });

    _channel.sink.add(jsonMessage);
  }

  void timingOKResponse() {
    final loginInfo = ref.read(loginInfoProvider);
    final jsonMessage = json.encode({
      "command": "TIMING_BELL_RES",
      "userId": loginInfo?.id ?? '',
      "debateId": state?.id ?? 0,
      "content": 'OK',
    });

    _channel.sink.add(jsonMessage);
  }

  void timingNOResponse() {
    final loginInfo = ref.read(loginInfoProvider);
    final jsonMessage = json.encode({
      "command": "TIMING_BELL_RES",
      "userId": loginInfo?.id ?? '',
      "debateId": state?.id ?? 0,
      "content": 'REJ',
    });

    _channel.sink.add(jsonMessage);
  }

  void alarmButton(BuildContext context) {
    final popupState = ref.read(popupProvider);
    final popupViewModel = ref.read(popupProvider.notifier);

    popupState.title = '토론 시작 시 알림을 보내드릴게요!';
    popupState.imgSrc = 'assets/icons/debatePopUpAlarm.svg';
    popupState.content = '토론 참여자가 정해지고 \n최종 토론이 개설 되면 \n푸시알림을 통해 알려드려요';
    popupState.buttonContentLeft = '네 알겠어요';

    popupState.buttonStyle = 1;

    popupViewModel.showDebatePopup(context);
  }

  void sendJoinMessage(BuildContext context) {
    final loginInfo = ref.read(loginInfoProvider);
    final message = controller.text;

    if (message.isEmpty) return;

    final jsonMessage = json.encode({
      "command": "JOIN",
      "userId": loginInfo?.id ?? '',
      "debateId": state?.id ?? 0,
      "content": message
    });
    print(jsonMessage);
    context.push("/showCase");
    _channel.sink.add(jsonMessage);

    controller.clear();
    focusNode.requestFocus();
  }

  void clear() {
    state = null;
    _messages.clear();
  }

  @override
  void dispose() {
    _channel.sink.close(status.goingAway);
    _messageController.close();
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }
}

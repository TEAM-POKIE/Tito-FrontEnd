import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/core/provider/ai_Response_Provider.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:tito_app/core/provider/userProfile_provider.dart';
import 'package:tito_app/src/data/models/api_response.dart';
import 'package:tito_app/src/data/models/debate_info.dart';
import 'package:tito_app/src/viewModel/timer_viewModel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:fluttertoast/fluttertoast.dart';

class ChatViewModel extends StateNotifier<DebateInfo?> {
  final Ref ref;
  TimerNotifier? timerNotifier;

  ChatViewModel(this.ref) : super(null) {
    connectWebSocket();
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

      if (mounted) {
        state = debateInfo;
      }
    } catch (error) {
      print('Error fetching debate info: $error');
      if (mounted) {
        state = null;
      }
    }
  }

  void connectWebSocket() {
    if (!mounted) return; // mounted 상태 체크

    _channel = WebSocketChannel.connect(
      Uri.parse('wss://dev.tito.lat/ws/debate'),
    );

    _liveChannel = WebSocketChannel.connect(
      Uri.parse('wss://dev.tito.lat/ws/debate/realtime'),
    );

    _channel.stream.listen((message) {
      if (message is String && message.startsWith('{')) {
        final decodedMessage = json.decode(message) as Map<String, dynamic>;
        if (mounted) {
          _messages.add(decodedMessage);
          _messageController.sink.add(decodedMessage);
        }
      } else {
        print('Invalid message format or non-JSON string received: $message');
      }
    }, onError: (error) {
      print('WebSocket error: $error');
    }, onDone: () {
      print('WebSocket connection closed');
    });

    _liveChannel.stream.listen((message) {
      print('Live Channel Message: $message');
    }, onError: (error) {
      print('Error in live channel: $error');
    }, onDone: () {
      print('Live channel connection closed');
    });
  }

  void updateExplanation(List<String>? explanation, String? contentEdited) {
    if (state != null) {
      state = state!.copyWith(
          explanation: explanation,
          contentEdited: contentEdited,
          isFirstClick: false,
          isLoading: false);
    }
  }

  void resetExplanation() {
    if (state != null) {
      state = state!.copyWith(
        explanation: [''],
        contentEdited: '',
        isLoading: false,
        isFirstClick: true,
      );
    }
    print(state!.isFirstClick);
  }

  void updateText() {
    if (mounted) {
      controller.text = state!.contentEdited;
    }
  }

  void resetText() {
    if (mounted) {
      controller.text = '';
    }
  }

  Future<void> createLLM() async {
    final chatNotifier = ref.read(chatInfoProvider.notifier);
    if (state == null || !mounted) return;

    state = state!.copyWith(isLoading: true);

    try {
      final message = controller.text;
      if (message.isEmpty) {
        throw Exception("Message is empty");
      }

      final responseString = await ApiService(DioClient.dio)
          .postRefineArgument({"argument": message});

      final Map<String, dynamic> response = jsonDecode(responseString);

      if (response.containsKey('data') &&
          response['data'] is Map<String, dynamic>) {
        final aiResponse = AiResponse.fromJson(response['data']);
        if (mounted) {
          ref.read(aiResponseProvider.notifier).setAiResponse(aiResponse);
          chatNotifier.updateExplanation(
              aiResponse.explanation, aiResponse.contentEdited);
        }
      } else {
        throw Exception("Unexpected data format or missing 'data' key");
      }
    } catch (e) {
      print("Error in sendMessage: $e");
    }
  }

  void sendMessage() {
    if (!mounted) return;
    final loginInfo = ref.read(loginInfoProvider);
    final message = controller.text;
    resetExplanation();
    if (message.isEmpty) return;

    final jsonMessage = json.encode({
      "command": "CHAT",
      "userId": loginInfo?.id ?? '',
      "debateId": state?.id ?? 0,
      "content": message,
    });

    print(jsonMessage);

    _channel.sink.add(jsonMessage);
    controller.clear();
    focusNode.requestFocus();
  }

  void sendVote(String selectedDebate) {
    if (!mounted) return;

    final loginInfo = ref.read(loginInfoProvider);
    final jsonMessage = json.encode({
      "command": "VOTE",
      "userId": loginInfo?.id ?? '',
      "debateId": state?.id ?? 0,
      "participantIsOwner":
          selectedDebate == state!.debateOwnerNick ? true : false,
    });

    print(jsonMessage);

    _liveChannel.sink.add(jsonMessage);
    controller.clear();
    focusNode.requestFocus();

    Fluttertoast.showToast(
        msg: "${selectedDebate}님을 투표하셨습니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void sendChatMessage() {
    if (!mounted) return;
    final loginInfo = ref.read(loginInfoProvider);
    final message = controller.text;

    if (message.isEmpty) return;
    state = state?.copyWith(isVoteEnded: false);
    final jsonMessage = json.encode({
      "command": "CHAT",
      "userId": loginInfo?.id ?? '',
      "debateId": state?.id ?? 0,
      "userNickName": loginInfo!.nickname,
      "userImgUrl": loginInfo.profilePicture ?? "",
      "content": message,
    });

    print(jsonMessage);
    _liveChannel.sink.add(jsonMessage);
    controller.clear();
    focusNode.requestFocus();
  }

  void sendFire() {
    if (!mounted) return;

    final jsonMessage = json.encode({
      "command": "FIRE",
      "debateId": state?.id ?? 0,
    });

    print(jsonMessage);
    _liveChannel.sink.add(jsonMessage);
    controller.clear();
    focusNode.requestFocus();
  }

  void getProfile(id, context) async {
    if (!mounted) return;

    final userInfo = await ApiService(DioClient.dio).getUserProfile(id);
    final popupViewModel = ref.read(popupProvider.notifier);
    final userProfileViewModel = ref.read(userProfileProvider.notifier);

    userProfileViewModel.setUserInfo(userInfo);
    popupViewModel.showUserPopup(context);
  }

  void getInfo(id, context) async {
    if (!mounted) return;

    if ((id == state!.debateOwnerId && state!.debateOwnerNick.isNotEmpty) ||
        (id == state!.debateJoinerId && state!.debateJoinerNick.isNotEmpty)) {
      return;
    }
    try {
      final userInfo = await ApiService(DioClient.dio).getUserProfile(id);
      final userProfileViewModel = ref.read(userProfileProvider.notifier);

      userProfileViewModel.setUserInfo(userInfo);

      if (id == state!.debateOwnerId) {
        state = state!.copyWith(
          debateOwnerNick: userInfo.nickname,
          debateOwnerPicture: userInfo.profilePicture ?? '',
        );
      } else if (id == state!.debateJoinerId) {
        state = state!.copyWith(
          debateJoinerNick: userInfo.nickname,
          debateJoinerPicture: userInfo.profilePicture ?? '',
        );
      }
    } catch (error) {
      print('Error fetching user info: $error');
    }
  }

  void timingSend() {
    if (!mounted) return;
    final loginInfo = ref.read(loginInfoProvider);
    final jsonMessage = json.encode({
      "command": "TIMING_BELL_REQ",
      "userId": loginInfo?.id ?? '',
      "debateId": state?.id ?? 0,
    });

    _channel.sink.add(jsonMessage);
  }

  void updateRemainTimer(Duration newRemainTimer) {
    if (mounted) {
      state!.remainingTime = newRemainTimer;
    }
  }

  void timingOKResponse() {
    if (!mounted) return;
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
    if (!mounted) return;
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
    if (!mounted) return;
    final popupState = ref.read(popupProvider);
    final popupViewModel = ref.read(popupProvider.notifier);

    popupState.title = '토론 시작 시 알림을 보내드릴게요!';
    popupState.imgSrc = 'assets/icons/bell_big_alarm.svg';
    popupState.content = '토론 참여자가 정해지고 \n최종 토론이 개설 되면 \n푸시알림을 통해 알려드려요';
    popupState.buttonContentLeft = '네 알겠어요';

    popupState.buttonStyle = 1;

    popupViewModel.showDebatePopup(context);
  }

  void sendJoinMessage(BuildContext context) {
    if (!mounted) return;
    final loginInfo = ref.read(loginInfoProvider);
    final message = controller.text;

    if (message.isEmpty) return;

    final jsonMessage = json.encode({
      "command": "JOIN",
      "userId": loginInfo?.id ?? '',
      "debateId": state?.id ?? 0,
      "content": message,
    });
    print(jsonMessage);

    if (loginInfo!.tutorialCompleted == false) {
      context.push("/showCase");
    }

    _channel.sink.add(jsonMessage);
    controller.clear();
    focusNode.requestFocus();
  }

  void clear() {
    if (!mounted) return;
    state = null;
    _messages.clear();
  }

  void enterChat(debateId, String debateStatus, BuildContext context) {
    if (!mounted) return;
    if (debateStatus == 'ENDED') {
      context.push('/endedChat/${debateId}');
    } else {
      final chatViewModel = ref.read(chatInfoProvider.notifier);
      chatViewModel.resetText();
      context.push('/chat/${debateId}');
    }
  }

  @override
  void dispose() {
    if (_channel != null) {
      _channel.sink.close(status.goingAway);
    }
    if (_liveChannel != null) {
      _liveChannel.sink.close(status.goingAway);
    }
    _messageController.close();
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/constants/web_sockey_service.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:tito_app/src/view/myPage/logout_popup.dart';
import 'package:tito_app/src/widgets/reuse/debate_popup.dart';

// PopupState 클래스 정의
class PopupState {
  String roomId;
  final Map<String, dynamic>? debateData;
  int? buttonStyle;
  String? title;
  String? content;
  String? buttonContentLeft;
  String? imgSrc;
  String? titleLabel;
  String? opponentNick;
  String? buttonContentRight;

  PopupState({
    this.roomId = '',
    this.debateData,
    this.buttonStyle,
    this.titleLabel,
    this.content,
    this.imgSrc,
    this.title,
    this.buttonContentLeft,
    this.opponentNick,
    this.buttonContentRight,
  });

  PopupState copyWith({
    String? roomId,
    String? opponentNick,
    String? title,
    String? titleLabel,
    String? content,
    String? buttonContentLeft,
    String? imgSrc,
    String? buttonContentRight,
    Map<String, dynamic>? debateData,
    int? buttonStyle,
  }) {
    return PopupState(
      roomId: roomId ?? this.roomId,
      opponentNick: opponentNick ?? this.opponentNick,
      title: title ?? this.title,
      titleLabel: titleLabel ?? this.titleLabel,
      imgSrc: imgSrc ?? this.imgSrc,
      buttonContentLeft: buttonContentLeft ?? this.buttonContentLeft,
      buttonContentRight: buttonContentRight ?? this.buttonContentRight,
      content: content ?? this.content,
      debateData: debateData ?? this.debateData,
      buttonStyle: buttonStyle ?? this.buttonStyle,
    );
  }
}

// PopupViewmodel 클래스 정의
class PopupViewmodel extends StateNotifier<PopupState> {
  final Ref ref;
  late WebSocketService webSocketService;

  PopupViewmodel(this.ref) : super(PopupState()) {
    // 웹소켓 서비스 초기화
    webSocketService = ref.read(webSocketProvider);
    webSocketService.listen((message) {
      _handleWebSocketMessage(message);
    });
  }

  // 웹소켓 메시지 처리
  void _handleWebSocketMessage(String message) {
    state = state.copyWith(
      title: '알림',
      content: message,
      buttonStyle: 1,
    );

    // 팝업을 띄우는 로직 (예시)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: ref.read(navigationContextProvider),
        builder: (BuildContext context) {
          return const DebatePopup();
        },
      );
    });
  }

  // 타이밍 팝업 띄우기
  Future<bool> showTimingPopup(BuildContext context) async {
    state = state.copyWith(
      title: '상대방이 타이밍 벨을 울렸어요!',
      content:
          '타이밍 벨을 울리시면 상대방의 동의에 따라\n마지막 최후 변론 후 토론이 종료돼요\n상대 거절 시 2턴 후 종료돼요',
      buttonStyle: 2,
      buttonContentLeft: "토론 더 할래요",
      buttonContentRight: '벨 울릴게요',
      titleLabel: '타이밍 벨',
      imgSrc: 'assets/images/popupTimingBell.png',
    );

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return const DebatePopup();
      },
    );

    return result ?? false; // return false if result is null
  }

  // 토론 팝업 띄우기
  Future<bool> showDebatePopup(BuildContext context) async {
    final loginInfo = ref.read(loginInfoProvider);

    if (loginInfo == null) {
      return false;
    }
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return const DebatePopup();
      },
    );

    return result ?? false; // return false if result is null
  }

  // 특정 상태로 팝업 띄우기
  void showPopup(PopupState popupState) {
    state = popupState;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: ref.read(navigationContextProvider),
        builder: (BuildContext context) {
          return const DebatePopup();
        },
      );
    });
  }
}

// 네비게이션 컨텍스트 프로바이더 (팝업을 띄우기 위한 컨텍스트 제공)
final navigationContextProvider = Provider<BuildContext>((ref) {
  throw UnimplementedError('navigationContextProvider not implemented');
});

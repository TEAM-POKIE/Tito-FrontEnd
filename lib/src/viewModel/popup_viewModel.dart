import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/src/data/models/popup_state.dart';
import 'package:tito_app/src/widgets/reuse/debate_popup.dart';
import 'package:tito_app/src/widgets/reuse/profile_popup.dart';
import 'package:tito_app/src/widgets/reuse/rule_pop_up.dart';

// PopupState 클래스 정의

// PopupViewmodel 클래스 정의
class PopupViewmodel extends StateNotifier<PopupState> {
  final Ref ref;

  PopupViewmodel(this.ref) : super(PopupState()) {
    // 웹소켓 서비스 초기화
    // webSocketService = ref.read(webSocketProvider);
    // webSocketService.listen((message) {
    //   _handleWebSocketMessage(message);
    // });
  }

  // 웹소켓 메시지 처리
  void _handleWebSocketMessage(String message) {
    state = state.copyWith(
      title: '알림',
      content: message,
      buttonStyle: 1,
    );
  }

  // 타이밍 팝업 띄우기
  Future<bool> showTimingPopup(BuildContext context) async {
    state = state.copyWith(
      title: '정말 토론을 끝내시려구요?',
      content:
          '타이밍 벨을 울리시면 상대방의 동의에 따라\n마지막 최후 변론 후 토론이 종료돼요\n상대 거절 시 2턴 후 종료돼요',
      buttonStyle: 2,
      buttonContentLeft: "토론 더 할래요",
      buttonContentRight: '벨 울릴게요',
      titleLabel: '타이밍 벨',
      imgSrc: 'assets/icons/popUpBell.svg',
    );

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return const DebatePopup();
      },
    );

    return result ?? false; // return false if result is null
  }

  // 타이밍 팝업 띄우기
  Future<bool> showTimingReceive(BuildContext context) async {
    state = state.copyWith(
      title: '상대방이 타이밍 벨을 울렸어요!',
      content: '승인 시 마지막 최후 변론 후 토론이 종료돼요\n거절 시 2턴 후 종료돼요',
      buttonStyle: 2,
      buttonContentLeft: "거절",
      buttonContentRight: '승인',
      titleLabel: '타이밍 벨',
      imgSrc: 'assets/icons/popUpBell.svg',
    );

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return const DebatePopup();
      },
    );

    return result ?? false; // return false if result is null
  }

  Future<bool> showEndPopup(BuildContext context) async {
    state = state.copyWith(
      title: '토론이 종료 됐어요!',
      content: '투표가 진행중이에요\n투표가 종료되면 알려드릴게요',
      buttonStyle: 0,
      imgSrc: 'assets/icons/chatIconRight.svg',
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

  Future<bool> showDeletePopup(BuildContext context) async {
    final loginInfo = ref.read(loginInfoProvider);
    state = state.copyWith(
      title: '토론을 삭제 하시겠어요?',
      content: '진짜루~',
      buttonStyle: 2,
      buttonContentLeft: "취소",
      buttonContentRight: '확인',
      imgSrc: 'assets/icons/chatIconRight.svg',
    );
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

  // 토론 팝업 띄우기
  Future<bool> showTitlePopup(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return const ProfilePopup();
      },
    );

    return result ?? false; // return false if result is null
  }

  Future<bool> showRulePopup(BuildContext context) async {
    final loginInfo = ref.read(loginInfoProvider);

    if (loginInfo == null) {
      return false;
    }
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return const RulePopUp();
      },
    );

    return result ?? false; // return false if result is null
  }
}

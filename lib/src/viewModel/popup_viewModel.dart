import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/src/data/models/popup_state.dart';
import 'package:tito_app/src/widgets/reuse/debateInfoPopup.dart';
import 'package:tito_app/src/widgets/reuse/debate_popup.dart';
import 'package:tito_app/src/widgets/reuse/profile_popup.dart';
import 'package:tito_app/src/widgets/reuse/rule_pop_up.dart';

class PopupViewmodel extends StateNotifier<PopupState> {
  final Ref ref;

  PopupViewmodel(this.ref) : super(PopupState()) {}

  void _handleWebSocketMessage(String message) {
    state = state.copyWith(
      title: '알림',
      content: message,
      buttonStyle: 1,
    );
  }

  void postBlock(id) async {
    await ApiService(DioClient.dio).postUserBlock({
      'blockUserId': id,
    });
  }

  // 타이밍 팝업 띄우기
  Future<bool> showTimingPopup(BuildContext context, String function) async {
    if (function == 'timing') {
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
    } else {
      state = state.copyWith(
        title: '토론의 승자를 투표해주세요!',
        buttonStyle: 1,
        buttonContentLeft: "투표 하기",
        imgSrc: 'assets/icons/debatePopUpAlarm.svg',
      );
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return const DebatePopup();
      },
    );

    return result ?? false; // return false if result is null
  }

  // 타이밍 팝업 띄우기
  Future<bool> showBlockPopup(BuildContext context) async {
    state = state.copyWith(
      title: '차단 하시겠어요?',
      content: '해당 유저와 토론할 수 없으며 개설된 토론 및 게시글이 더 이상 노출되지 않습니다',
      buttonStyle: 2,
      buttonContentLeft: "취소",
      buttonContentRight: '확인',
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

// Future<bool> showLogoutPopup(BuildContext context) async {
//     state = state.copyWith(
//       title: '정말로 로그아웃 하시겠어요?',
//       content: '로그아웃 하시면\n추후 앱을 이용하실 때\n다시 로그인을 해야해요',
//       buttonStyle: 1,
//       buttonContentLeft: "로그아웃 하기",
//       imgSrc: 'assets/icons/chatIconRight.svg',
//     );

//     final result = await showLogoutPopup<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return const DebatePopup();
//       },
//     );

//     return result ?? false; // return false if result is null
//   }

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

    return result ?? false;
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

    return result ?? false;
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

    return result ?? false;
  }

  Future<bool> showDeletePopup(BuildContext context) async {
    final loginInfo = ref.read(loginInfoProvider);
    state = state.copyWith(
      title: '토론을 삭제 하시겠어요?',
      content: '토론을 삭제하면 돌이킬 수 없습니다.',
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

    return result ?? false;
  }

  // 토론 팝업 띄우기
  Future<bool> showTitlePopup(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return const Debateinfopopup();
      },
    );

    return result ?? false;
  }

  Future<bool> showUserPopup(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return const ProfilePopup();
      },
    );

    return result ?? false;
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

    return result ?? false;
  }
}

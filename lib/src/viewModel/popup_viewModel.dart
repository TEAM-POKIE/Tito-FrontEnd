import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:tito_app/src/widgets/reuse/debate_popup.dart';

class PopupState {
  final String roomId;
  final Map<String, dynamic>? debateData;
  int? buttonStyle;
  String? title;
  String? content;
  String? buttonContentLeft;
  String? imgSrc;
  String? titleLabel;

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
    this.buttonContentRight,
  });

  PopupState copyWith({
    String? roomId,
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

class PopupViewmodel extends StateNotifier<PopupState> {
  final Ref ref;

  PopupViewmodel(this.ref) : super(PopupState());

  Future<bool> showTimingPopup(
    BuildContext context,
  ) async {
    final loginInfo = ref.read(loginInfoProvider);
    final popupState = ref.read(popupProvider);

    popupState.title = '상대방이 타이밍 벨을 울렸어요!';
    popupState.content =
        '타이밍 벨을 울리시면 상대방의 동의에 따라\n마지막 최후 변론 후 토론이 종료돼요\n상대 거절 시 2턴 후 종료돼요';
    popupState.buttonStyle = 2;
    popupState.buttonContentLeft = "토론 더 할래요";
    popupState.buttonContentRight = '벨 울릴게요';
    popupState.titleLabel = '타이밍 벨';
    popupState.imgSrc = 'assets/images/popupTimingBell.png';
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

  Future<bool> showDebatePopup(
    BuildContext context,
  ) async {
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

  void showPopup(PopupState popupState) {}
}

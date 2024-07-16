import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/src/widgets/reuse/debate_popup.dart';

class PopupState {
  final String roomId;
  final Map<String, dynamic>? debateData;

  PopupState({
    this.roomId = '',
    this.debateData,
  });

  PopupState copyWith({
    String? roomId,
    Map<String, dynamic>? debateData,
  }) {
    return PopupState(
      roomId: roomId ?? this.roomId,
      debateData: debateData ?? this.debateData,
    );
  }
}

class PopupViewmodel extends StateNotifier<PopupState> {
  final Ref ref;

  PopupViewmodel(this.ref) : super(PopupState());

  Future<bool> showDebatePopup(
      BuildContext context, String title, String content) async {
    final loginInfo = ref.read(loginInfoProvider);
    if (loginInfo == null) {
      return false;
    }
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return DebatePopup(
          debateId: state.roomId,
          title: title,
          nick: loginInfo.nickname,
          content: content,
          onUpdate: (opponentNick) {
            state = state.copyWith(
              debateData: {
                ...?state.debateData,
                'opponentNick': opponentNick,
              },
            );
          },
        );
      },
    );

    return result ?? false; // return false if result is null
  }
}

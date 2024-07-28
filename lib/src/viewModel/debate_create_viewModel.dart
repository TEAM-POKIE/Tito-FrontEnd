import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/provider/live_comment.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:tito_app/src/data/models/debate_crate.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/viewModel/popup_viewModel.dart';

class DebateCreateViewModel extends StateNotifier<DebateCreateState> {
  final Ref ref;
  final WebSocketService _webSocketService = WebSocketService();

  DebateCreateViewModel(this.ref) : super(DebateCreateState());

  final List<String> labels = ['연애', '정치', '연예', '자유', '스포츠'];

  void updateTitle(String title) {
    state = state.copyWith(debateTitle: title);
  }

  void updateCategory(int index) {
    state = state.copyWith(debateCategory: labels[index]);
  }

  void updateContent(String content) {
    state = state.copyWith(firstChatContent: content);
  }

  void showDebatePopup(BuildContext context) {
    final popupState = ref.read(popupProvider);
    final popupViewModel = ref.read(popupProvider.notifier);

    popupState.title = '토론 시작 시 알림을 보내드릴게요!';
    popupState.imgSrc = 'assets/images/debatePopUpAlarm.png';
    popupState.content = '토론 참여자가 정해지고 \n최종 토론이 개설 되면 \n푸시알림을 통해 알려드려요';
    popupState.buttonContentLeft = '네 알겠어요';
    popupState.buttonStyle = 1;

    popupViewModel.showDebatePopup(context);
  }

  void showRulePopup(BuildContext context) {
    final popupViewModel = ref.read(popupProvider.notifier);
    popupViewModel.showRulePopup(context);
  }

  void sendMessage(BuildContext context, TextEditingController controller) {
    final text = controller.text;
    if (text.isNotEmpty) {
      // 메시지를 서버로 전송하는 API 호출 로직

      controller.clear();
      context.push('/chat');
    }
  }

  bool validateForm(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  void saveForm(GlobalKey<FormState> formKey) {
    formKey.currentState?.save();
  }

  void nextChat(GlobalKey<FormState> formKey, BuildContext context) {
    if (!validateForm(formKey)) {
      return;
    }
    saveForm(formKey);
    context.push('/debate_create_chat');
  }
}

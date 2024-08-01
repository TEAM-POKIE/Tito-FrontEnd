import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/provider/live_comment.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:tito_app/src/data/models/debate_crate.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/viewModel/popup_viewModel.dart';

enum DebateCategory {
  ROMANCE('연애', 'ROMANCE'),
  POLITICS('정치', 'POLITICS'),
  ENTERTAINMENT('연예', 'ENTERTAINMENT'),
  FREE('자유', 'FREE'),
  SPORTS('스포츠', 'SPORTS');

  final String label;
  final String value;

  const DebateCategory(this.label, this.value);
}

class DebateCreateViewModel extends StateNotifier<DebateCreateState> {
  final Ref ref;

  DebateCreateViewModel(this.ref) : super(DebateCreateState());

  final List<String> labels =
      DebateCategory.values.map((e) => e.label).toList();

  void updateTitle(String title) {
    state = state.copyWith(debateTitle: title);
  }

  void updateCategory(int index) {
    String selectedLabel = labels[index];
    String? selectedCategory = DebateCategory.values
        .firstWhere((category) => category.label == selectedLabel)
        .value;
    state = state.copyWith(debateCategory: selectedCategory);
  }

  void updateContent(String content) {
    state = state.copyWith(firstChatContent: content);
  }

  void updateOpinion(String aOpinion, String bOpinion) {
    state = state.copyWith(
        debateMakerOpinion: aOpinion, debateJoinerOpinion: bOpinion);
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:tito_app/src/data/models/debate_crate.dart';
import 'package:go_router/go_router.dart';

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
  final ImagePicker _picker = ImagePicker();
  File? debateImageFile;
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
    state = state.copyWith(debateContent: content);
  }

  void updateOpinion(String aOpinion, String bOpinion) {
    state = state.copyWith(
        debateMakerOpinion: aOpinion, debateJoinerOpinion: bOpinion);
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      debateImageFile = File(pickedFile.path);

      state = state.copyWith(debateImageUrl: debateImageFile!.path);
    }
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

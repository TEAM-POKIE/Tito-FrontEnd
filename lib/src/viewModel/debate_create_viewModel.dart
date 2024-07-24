import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tito_app/src/data/models/debate_crate.dart';
import 'package:go_router/go_router.dart';

class DebateCreateViewModel extends StateNotifier<DebateCreateState> {
  DebateCreateViewModel() : super(DebateCreateState());

  final ImagePicker _picker = ImagePicker();
  final List<String> labels = ['연애', '정치', '연예', '자유', '스포츠'];

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updateCategory(int index) {
    state = state.copyWith(category: labels[index]);
  }

  void updateContent(String content) {
    state = state.copyWith(content: content);
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      state = state.copyWith(image: image);
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

    // 다음 화면으로 이동
    context.push('/debate_create_chat');
  }
}

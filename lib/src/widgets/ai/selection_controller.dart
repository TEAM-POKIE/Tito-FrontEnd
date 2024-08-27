import 'dart:convert'; // JSON 디코딩을 위해 필요
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/src/data/models/ai_word.dart';

class SelectionState {
  final List<int> selectedItems;
  final bool isLoading;
  final List<AiWord> topics;
  final int expandedIndex; // 확장된 인덱스를 추적하기 위한 변수

  SelectionState({
    this.selectedItems = const [],
    this.isLoading = false,
    this.topics = const [],
    this.expandedIndex = -1, // 기본값은 -1로 설정하여 아무것도 확장되지 않도록 함
  });

  SelectionState copyWith({
    List<int>? selectedItems,
    bool? isLoading,
    List<AiWord>? topics,
    int? expandedIndex,
  }) {
    return SelectionState(
      selectedItems: selectedItems ?? this.selectedItems,
      isLoading: isLoading ?? this.isLoading,
      topics: topics ?? this.topics,
      expandedIndex: expandedIndex ?? this.expandedIndex,
    );
  }
}

class SelectionNotifier extends StateNotifier<SelectionState> {
  SelectionNotifier() : super(SelectionState());

  void toggleSelection(int index) {
    final selectedItems = List<int>.from(state.selectedItems);
    if (selectedItems.contains(index)) {
      selectedItems.remove(index);
    } else {
      selectedItems.add(index);
    }
    state = state.copyWith(selectedItems: selectedItems);
  }

  void toggleExpandedIndex(int index) {
    final newExpandedIndex = state.expandedIndex == index ? -1 : index;
    state = state.copyWith(expandedIndex: newExpandedIndex);
  }

  Future<void> resetSelection() async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await ApiService(DioClient.dio).postGenerateTopic({
        "words": ["바나나", "사랑", "안은소"]
      });

      final Map<String, dynamic> decodedResponse = json.decode(response);
      final List<dynamic> responseData =
          decodedResponse['data'] as List<dynamic>;
      final List<AiWord> aiWords = responseData
          .map((item) => AiWord.fromJson(item as Map<String, dynamic>))
          .toList();

      state = state.copyWith(topics: aiWords);
    } catch (e) {
      print('Error fetching topics: $e');
      // Error handling
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

import 'dart:convert'; // JSON 디코딩을 위해 필요
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/src/data/models/ai_random_word.dart';
import 'package:tito_app/src/data/models/ai_word.dart';

class SelectionState {
  final List<int> selectedItems;
  final bool isLoading;
  final List<AiWord> topics;
  final List<AiRandomWord> randomWord;
  final int expandedIndex;

  SelectionState({
    this.selectedItems = const [],
    this.isLoading = false,
    this.topics = const [],
    this.randomWord = const [],
    this.expandedIndex = -1,
  });

  SelectionState copyWith({
    List<int>? selectedItems,
    bool? isLoading,
    List<AiWord>? topics,
    List<AiRandomWord>? randomWord,
    int? expandedIndex,
  }) {
    return SelectionState(
      selectedItems: selectedItems ?? this.selectedItems,
      isLoading: isLoading ?? this.isLoading,
      topics: topics ?? this.topics,
      expandedIndex: expandedIndex ?? this.expandedIndex,
      randomWord: randomWord ?? this.randomWord,
    );
  }
}

class SelectionNotifier extends StateNotifier<SelectionState> {
  SelectionNotifier() : super(SelectionState());

  // 토글 기능을 통해 선택 상태를 관리
  void toggleSelection(int index) {
    final selectedItems = List<int>.from(state.selectedItems);
    if (selectedItems.contains(index)) {
      selectedItems.remove(index);
    } else {
      selectedItems.add(index);
    }
    state = state.copyWith(selectedItems: selectedItems);
  }

  // 확장된 인덱스를 관리하는 메서드
  void toggleExpandedIndex(int index) {
    final newExpandedIndex = state.expandedIndex == index ? -1 : index;
    state = state.copyWith(expandedIndex: newExpandedIndex);
  }

  // AI 주제를 생성하는 메서드
  Future<void> createSelection() async {
    state = state.copyWith(isLoading: true);

    try {
      final List<String> selectedWords = state.selectedItems
          .map((index) => state.randomWord[index].word)
          .toList();
      print(selectedWords);
      final response = await ApiService(DioClient.dio)
          .postGenerateTopic({"words": selectedWords});

      final Map<String, dynamic> decodedResponse = json.decode(response);
      final List<dynamic> responseData =
          decodedResponse['data'] as List<dynamic>;
      final List<AiWord> aiWords = responseData
          .map((item) => AiWord.fromJson(item as Map<String, dynamic>))
          .toList();

      state = state.copyWith(topics: aiWords);
    } catch (e) {
      print('Error fetching topics: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // AI 주제를 생성하는 메서드
  Future<void> getWord() async {
    try {
      final response = await ApiService(DioClient.dio).getRandomWord();

      final Map<String, dynamic> decodedResponse = json.decode(response);
      final List<dynamic> responseData =
          decodedResponse['data'] as List<dynamic>;
      final List<AiRandomWord> randomword = responseData
          .map((item) => AiRandomWord.fromJson(item as Map<String, dynamic>))
          .toList();

      state = state.copyWith(randomWord: randomword);
    } catch (e) {
      print('Error fetching topics: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // 선택 상태를 초기화하는 메서드
  void resetSelection() {
    state = state.copyWith(
      selectedItems: [],
      expandedIndex: -1,
    );
  }
}

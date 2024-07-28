import 'package:tito_app/src/data/models/types.dart' as types;

class ChatState {
  final List<types.Message> messages;
  final bool isFirstMessage;
  final bool? isVisible;
  final String fadeText;

  final Map<String, dynamic>? debateData;

  ChatState({
    this.messages = const [],
    this.isFirstMessage = true,
    this.fadeText = '첫 채팅을 입력해주세요!',
    this.debateData,
    this.isVisible = true,
  });

  ChatState copyWith({
    List<types.Message>? messages,
    bool? isFirstMessage,
    bool? isVisible,
    String? fadeText,
    Map<String, dynamic>? debateData,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isFirstMessage: isFirstMessage ?? this.isFirstMessage,
      fadeText: fadeText ?? this.fadeText,
      isVisible: isVisible ?? this.isVisible,
      debateData: debateData ?? this.debateData,
    );
  }
}

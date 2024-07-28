class PopupState {
  String roomId;
  final Map<String, dynamic>? debateData;
  int? buttonStyle;
  String? title;
  String? content;
  String? buttonContentLeft;
  String? imgSrc;
  String? titleLabel;
  String? opponentNick;
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
    this.opponentNick,
    this.buttonContentRight,
  });

  PopupState copyWith({
    String? roomId,
    String? opponentNick,
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
      opponentNick: opponentNick ?? this.opponentNick,
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

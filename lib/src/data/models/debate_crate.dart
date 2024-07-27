import 'package:image_picker/image_picker.dart';

class DebateCreateState {
  final String title;
  final String category;
  final String content;
  final String myNick;
  String aArgument;
  String firstSend;
  String bArgument;
  final XFile? image;

  DebateCreateState({
    this.title = '',
    this.myNick = '',
    this.aArgument = '',
    this.bArgument = '',
    this.category = '',
    this.content = '',
    this.firstSend = '',
    this.image,
  });

  DebateCreateState copyWith({
    String? title,
    String? category,
    String? content,
    String? myNick,
    String? aArgument,
    String? bArgument,
    String? firstSend,
    XFile? image,
  }) {
    return DebateCreateState(
      title: title ?? this.title,
      category: category ?? this.category,
      content: content ?? this.content,
      myNick: myNick ?? this.myNick,
      image: image ?? this.image,
      firstSend: firstSend ?? this.firstSend,
      aArgument: aArgument ?? this.aArgument,
      bArgument: bArgument ?? this.bArgument,
    );
  }
}

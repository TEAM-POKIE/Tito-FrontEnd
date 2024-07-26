import 'package:image_picker/image_picker.dart';

class DebateCreateState {
  final String title;
  final String category;
  final String content;
  final XFile? image;

  DebateCreateState({
    this.title = '',
    this.category = '',
    this.content = '',
    this.image,
  });

  DebateCreateState copyWith({
    String? title,
    String? category,
    String? content,
    XFile? image,
  }) {
    return DebateCreateState(
      title: title ?? this.title,
      category: category ?? this.category,
      content: content ?? this.content,
      image: image ?? this.image,
    );
  }
}

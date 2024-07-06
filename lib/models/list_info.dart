class ListBanner {
  const ListBanner({
    required this.id,
    required this.title,
    required this.content,
  });
  final String id;
  final String title;
  final String content;
}

class HotList {
  const HotList({
    required this.id,
    required this.hotTitle,
    required this.hotContent,
    required this.hotScore,
  });
  final String id;
  final String hotTitle;
  final String hotContent;
  final int hotScore;
}

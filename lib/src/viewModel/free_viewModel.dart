import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/data/models/freescreen_info.dart';

class FreeViewmodel extends StateNotifier<List<FreeState>> {
  FreeViewmodel() : super(freeDummydata) {
    _init();
  }

  void _init() {
    // 초기화 작업
  }

  Future<void> addPost(BuildContext context) async {
    final newItem = await context.push<FreeState>('/write');

    if (newItem == null) {
      return;
    }

    state = [newItem, ...state];
  }

  void navigateToDetail(BuildContext context, String id) {
    context.push('/detail/$id');
  }

  void removePost(FreeState item) {
    state = state.where((element) => element.id != item.id).toList();
  }

  String timeAgo(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);

    if (duration.inDays > 1) {
      return '${duration.inDays}일 전';
    } else if (duration.inDays == 1) {
      return '어제';
    } else if (duration.inHours > 1) {
      return '${duration.inHours}시간 전';
    } else if (duration.inHours == 1) {
      return '한 시간 전';
    } else if (duration.inMinutes > 1) {
      return '${duration.inMinutes}분 전';
    } else if (duration.inMinutes == 1) {
      return '1분 전';
    } else if (duration.inSeconds >= 0) {
      return '방금 전';
    }
    return '';
  }
}

final List<FreeState> freeDummydata = List.generate(20, (index) {
  return FreeState(
    id: index.toString(),
    title: 'Title $index',
    content: 'This is the content for item $index',
    timestamp: DateTime.now().subtract(Duration(days: index)),
  );
});

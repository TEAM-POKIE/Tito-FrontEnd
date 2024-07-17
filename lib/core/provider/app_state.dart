import 'package:flutter/material.dart';
import 'package:tito_app/src/data/models/freescreen_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/viewModel/free_viewModel.dart';

final freeViewModelProvider = StateNotifierProvider<FreeViewmodel, List<FreeState>>(
  (ref) => FreeViewmodel(),
);

class AppState extends ChangeNotifier {
  final Map<String, int> _likeCounts = {};

  int getLikeCount(String postId) {
    return _likeCounts[postId] ?? 0;
  }

  void setLikeCount(String postId, int newCount) {
    _likeCounts[postId] = newCount;
    notifyListeners();
  }

  void incrementLikes(String postId) {
    _likeCounts[postId] = (_likeCounts[postId] ?? 0) + 1;
    notifyListeners();
  }

  void decrementLikes(String postId) {
    _likeCounts[postId] = (_likeCounts[postId] ?? 0) - 1;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:tito_app/src/data/models/freescreen_item.dart';

class AppState extends ChangeNotifier {
  Map<String, int> _likeCounts = {};

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

//final AppState appState = AppState();

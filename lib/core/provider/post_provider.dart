import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class Post {
  final String title;
  final String content;

  const Post ({required this.title, required this.content});
}

class PostNotifier extends StateNotifier<List<Post>> {
  PostNotifier() : super([]);

  void addPost(Post post) {
    //[...state, post]는 현재 상태인 state 리스트에 새로운 post를 추가하여 새로운 리스트를 만듦
    state = [...state,post];
    //스프레드 연산자(...)를 사용하여 기존 리스트 state의 모든 요소를 새로운 리스트에 복사하고, 마지막에 새로운 post를 추가힘
    //예를 들어, state가 [Post(title: '첫 번째', content: '첫 번째 내용')]이라면, 새로운 post가 추가된 후의 상태는 [Post(title: '첫 번째', content: '첫 번째 내용'), Post(title: '새 제목', content: '새 내용')]가 됩니다.
  }
}


final postProvider = StateNotifierProvider<PostNotifier, List<Post>>((ref) {
  return PostNotifier();
});


final titleControllerProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});

final contentControllerProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});


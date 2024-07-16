import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tito_app/src/data/models/list_info.dart';
import 'package:tito_app/core/constants/api_path.dart';

// State class
class HomeState {
  final List<String> titles;
  final List<String> contents;
  final List<HotList> hotItems;
  final bool isLoading;
  final bool hasError;

  HomeState({
    this.titles = const [],
    this.contents = const [],
    this.hotItems = const [],
    this.isLoading = true,
    this.hasError = false,
  });

  HomeState copyWith({
    List<String>? titles,
    List<String>? contents,
    List<HotList>? hotItems,
    bool? isLoading,
    bool? hasError,
  }) {
    return HomeState(
      titles: titles ?? this.titles,
      contents: contents ?? this.contents,
      hotItems: hotItems ?? this.hotItems,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }
}

// StateNotifier class
class HomeViewmodel extends StateNotifier<HomeState> {
  HomeViewmodel() : super(HomeState()) {
    _init();
  }

  final PageController _controller = PageController();
  PageController get controller => _controller;

  Future<void> _init() async {
    await fetchTitles();
    await hotList();
  }

  // void goMyPage(BuildContext context) {
  //  context.push('/mypage')
  // }

  void goListPage(BuildContext context) {
    context.push('list');
  }

  Future<void> fetchTitles() async {
    try {
      final response = await ApiService.getData('live_debate_list');

      final List<ListBanner> loadedItems = [];
      for (final item in response!.entries) {
        loadedItems.add(
          ListBanner(
            id: item.key,
            title: item.value['title'],
            content: item.value['content'],
          ),
        );
      }

      state = state.copyWith(
        titles: loadedItems.map((item) => item.title).toList(),
        contents: loadedItems.map((item) => item.content).toList(),
        isLoading: false,
      );
    } catch (error) {
      state = state.copyWith(
        hasError: true,
        isLoading: false,
      );
      // UI쪽에서 Snackbar나 에러처리를 해야함
    }
  }

  Future<void> hotList() async {
    try {
      final response = await ApiService.getData('hot_debate_list');

      final List<HotList> hotItems = [];
      for (final item in response!.entries) {
        hotItems.add(
          HotList(
            id: item.key,
            hotTitle: item.value['title'],
            hotContent: item.value['content'],
            hotScore: item.value['hot_count'],
          ),
        );
      }

      state = state.copyWith(
        hotItems: hotItems,
        isLoading: false,
      );
    } catch (error) {
      state = state.copyWith(
        hasError: true,
        isLoading: false,
      );
      // UI쪽에서 Snackbar나 에러처리를 해야함
    }
  }
}

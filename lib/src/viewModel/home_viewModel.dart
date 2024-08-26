import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/src/data/models/debate_benner.dart';
import 'package:tito_app/src/data/models/debate_hotdebate.dart';
import 'package:tito_app/src/data/models/debate_hotfighter.dart';

class HomeState {
  final List<DebateBenner> debateBanners;
  final List<DebateHotdebate> hotlist;
  final List<DebateHotfighter> hotfighter;
  final bool isLoading;
  final bool hasError;

  HomeState({
    this.debateBanners = const [],
    this.hotlist = const [],
    this.hotfighter = const [],
    this.isLoading = true,
    this.hasError = false,
  });

  HomeState copyWith({
    List<DebateBenner>? debateBanners,
    List<DebateHotdebate>? hotlist,
    List<DebateHotfighter>? hotfighter,
    bool? isLoading,
    bool? hasError,
  }) {
    return HomeState(
      debateBanners: debateBanners ?? this.debateBanners,
      hotfighter: hotfighter ?? this.hotfighter,
      hotlist: hotlist ?? this.hotlist,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }
}

class HomeViewModel extends StateNotifier<HomeState> {
  HomeViewModel() : super(HomeState());

  final ApiService apiService = ApiService(DioClient.dio);

  Future<void> hotList() async {
    try {
      final String response = await apiService.getDebateBenner();
      final Map<String, dynamic> decodedResponse =
          json.decode(response) as Map<String, dynamic>;
      final List<dynamic> dataList = decodedResponse['data'] as List<dynamic>;

      final List<DebateBenner> debateBanners = dataList
          .map((item) => DebateBenner.fromJson(item as Map<String, dynamic>))
          .toList();

      state = state.copyWith(
        debateBanners: debateBanners,
        isLoading: false,
        hasError: false,
      );
    } catch (error) {
      print('Error fetching debate banners: $error');
      state = state.copyWith(
        hasError: true,
        isLoading: false,
      );
    }
  }

  Future<void> fetchHotDebates() async {
    try {
      final String response = await apiService.getDebateHotdebate();
      final Map<String, dynamic> decodedResponse =
          json.decode(response) as Map<String, dynamic>;
      final List<dynamic> dataList = decodedResponse['data'] as List<dynamic>;

      final List<DebateHotdebate> hotDebates = dataList
          .map((item) => DebateHotdebate.fromJson(item as Map<String, dynamic>))
          .toList();

      state = state.copyWith(
        hotlist: hotDebates,
        isLoading: false,
        hasError: false,
      );
    } catch (e) {
      print('Error fetching debates: $e');
      state = state.copyWith(
        hasError: true,
        isLoading: false,
      );
    }
  }

  Future<void> fetchHotfighter() async {
    try {
      final String response = await apiService.getDebateHotfighter();
      final Map<String, dynamic> decodedResponse =
          json.decode(response) as Map<String, dynamic>;
      final List<dynamic> dataList = decodedResponse['data'] as List<dynamic>;

      final List<DebateHotfighter> hotFighters = dataList
          .map(
              (item) => DebateHotfighter.fromJson(item as Map<String, dynamic>))
          .toList();

      state = state.copyWith(
        hotfighter: hotFighters,
        isLoading: false,
        hasError: false,
      );
    } catch (e) {
      print('Error fetching debates: $e');
      state = state.copyWith(
        hasError: true,
        isLoading: false,
      );
    }
  }
}

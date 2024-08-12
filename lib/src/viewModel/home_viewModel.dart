import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/src/data/models/debate_benner.dart';

class HomeState {
  final List<DebateBenner> debateBanners;
  final bool isLoading;
  final bool hasError;

  HomeState({
    this.debateBanners = const [],
    this.isLoading = true,
    this.hasError = false,
  });

  HomeState copyWith({
    List<DebateBenner>? debateBanners,
    bool? isLoading,
    bool? hasError,
  }) {
    return HomeState(
      debateBanners: debateBanners ?? this.debateBanners,
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
      // API에서 DebateBenner 객체의 리스트를 가져옴
      final List<DebateBenner> debateBanners =
          await apiService.getDebateBenner();

      // 가져온 데이터를 출력해서 확인
      print('Fetched debate banners: $debateBanners');

      // 상태를 업데이트
      state = state.copyWith(
        debateBanners: debateBanners,
        isLoading: false,
      );
    } catch (error) {
      print('Error fetching debate banners: $error');
      state = state.copyWith(
        hasError: true,
        isLoading: false,
      );
    }
  }
}

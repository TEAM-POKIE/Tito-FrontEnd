import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/provider/home_state_provider.dart';
import 'dart:async'; // Timer를 사용하기 위해 추가
import 'package:go_router/go_router.dart'; // context.push를 사용하기 위해 추가

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  late final PageController _pageController;
  late final Timer _timer;
  int _currentPage = 1; // 복제된 첫 번째 배너에서 시작

  @override
  void initState() {
    super.initState();
    // PageController 초기화
    _pageController = PageController(initialPage: _currentPage);

    // 데이터를 가져옵니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeViewModel = ref.read(homeViewModelProvider.notifier);
      homeViewModel.hotList();
    });

    // 2초마다 페이지 넘기기
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel(); // 타이머 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);

    if (homeState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (homeState.hasError) {
      return const Center(child: Text('데이터를 불러오는 중 오류가 발생했습니다.'));
    }

    if (homeState.debateBanners.isEmpty) {
      return const Center(child: Text('토론 데이터가 없습니다.'));
    }

    // 첫 번째와 마지막 배너를 복제하여 무한 루프처럼 보이도록 설정
    final banners = homeState.debateBanners;
    final infiniteBanners = [
      banners.last, // 마지막 배너를 첫 번째로 복제
      ...banners,
      banners.first, // 첫 번째 배너를 마지막으로 복제
    ];

    return Column(
      children: [
        SizedBox(
          height: 200.h,
          child: PageView.builder(
            controller: _pageController, // PageController 연결
            itemCount: infiniteBanners.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });

              // 첫 번째 복제 페이지로 이동한 경우 실제 첫 번째 페이지로 점프
              if (index == 0) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  _pageController.jumpToPage(banners.length);
                });
              }
              // 마지막 복제 페이지로 이동한 경우 실제 첫 번째 페이지로 점프
              else if (index == banners.length + 1) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  _pageController.jumpToPage(1);
                });
              }
            },
            itemBuilder: (context, index) {
              final debate = infiniteBanners[index];
              return GestureDetector(
                onTap: () {
                  // 배너 클릭 시 해당 아이디로 페이지 이동
                  context.push('/chat/${debate.id}');
                },
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.h, horizontal: 5.w),
                  child: Container(
                    width: 352.w,
                    height: 140.h,
                    decoration: BoxDecoration(
                      color: ColorSystem.black,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '불 붙은 실시간 토론 🔥',
                                style: FontSystem.KR14M
                                    .copyWith(color: ColorSystem.white),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 5.h),
                                decoration: BoxDecoration(
                                  color: ColorSystem.purple,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  '실시간 토론 중',
                                  style: FontSystem.KR14M
                                      .copyWith(color: ColorSystem.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            debate.debateTitle,
                            style: FontSystem.KR16B
                                .copyWith(color: ColorSystem.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Text(
                                debate.debateMakerOpinion,
                                style: FontSystem.KR16B
                                    .copyWith(color: ColorSystem.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'vs',
                                style: FontSystem.KR16B
                                    .copyWith(color: ColorSystem.white),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  debate.debateJoinerOpinion,
                                  style: FontSystem.KR16B
                                      .copyWith(color: ColorSystem.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SmoothPageIndicator(
          controller: _pageController, // 동일한 PageController 사용
          count: banners.length,
          effect: WormEffect(
            dotWidth: 6.w,
            dotHeight: 6.h,
            activeDotColor: ColorSystem.black,
            dotColor: ColorSystem.grey,
          ),
        ),
      ],
    );
  }
}

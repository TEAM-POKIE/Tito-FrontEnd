import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/provider/home_state_provider.dart';
import 'package:tito_app/src/viewModel/home_viewModel.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    // PageController 초기화
    _pageController = PageController();

    // 데이터를 가져옵니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeViewModel = ref.read(homeViewModelProvider.notifier);
      homeViewModel.hotList();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);

    if (homeState.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    print(homeState.debateBanners);

    if (homeState.hasError) {
      return Center(child: Text('데이터를 불러오는 중 오류가 발생했습니다.'));
    }

    return Column(
      children: [
        SizedBox(
          height: 200.h, // PageView의 높이를 조정
          child: PageView.builder(
            controller: _pageController, // PageController 연결
            itemCount: homeState.debateBanners.length,
            itemBuilder: (context, index) {
              final debate = homeState.debateBanners[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorSystem.black,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '불 붙은 실시간 토론🔥',
                              style: FontSystem.KR14M.copyWith(
                                color: ColorSystem.white,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 5.h),
                              decoration: BoxDecoration(
                                color: ColorSystem.purple,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                debate.debateStatus,
                                style: FontSystem.KR14M.copyWith(
                                  color: ColorSystem.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          debate.debateTitle,
                          style: const TextStyle(
                            color: ColorSystem.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Text(
                              debate.debateMakerOpinion,
                              style: const TextStyle(
                                color: ColorSystem.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'vs',
                              style: FontSystem.KR16B
                                  .copyWith(color: ColorSystem.white),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              debate.debateJoinerOpinion,
                              style: const TextStyle(
                                color: ColorSystem.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SmoothPageIndicator(
          controller: _pageController, // 동일한 PageController 사용
          count: homeState.debateBanners.length,
          effect: const WormEffect(
            dotWidth: 10.0,
            dotHeight: 10.0,
            activeDotColor: ColorSystem.black,
            dotColor: ColorSystem.grey,
          ),
        ),
      ],
    );
  }
}

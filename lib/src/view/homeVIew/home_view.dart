import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tito_app/core/provider/home_state_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final homeViewModel = ref.read(homeViewModelProvider.notifier);

    return Column(
      children: [
        SizedBox(
          height: 180, // PageView의 높이를 조정
          child: PageView.builder(
            controller: homeViewModel.controller,
            itemCount: homeState.titles.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorSystem.black,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(
                        horizontal: 20.w, vertical: 30.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '불 붙은 실시간 토론🔥',
                                    style: TextStyle(color: ColorSystem.white),
                                  ),
                                  Container(
                                    // padding: EdgeInsets.symmetric(
                                    //     horizontal: 10.w, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: ColorSystem.purple,
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: const Text(
                                      '실시간 토론중',
                                      style: TextStyle(color: ColorSystem.white),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return SizedBox(
                                    width: constraints.maxWidth * 0.8,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          homeState.titles[index],
                                          style: const TextStyle(
                                            color: ColorSystem.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          homeState.contents[index],
                                          style: const TextStyle(
                                            color: ColorSystem.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
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
          controller: homeViewModel.controller,
          count: homeState.titles.length,
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

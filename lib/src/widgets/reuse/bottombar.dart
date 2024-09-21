import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/home_state_provider.dart';
import 'package:tito_app/core/provider/nav_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomBar extends ConsumerStatefulWidget {
  const BottomBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _BottomBarState();
  }
}

class _BottomBarState extends ConsumerState<BottomBar> {
  void _onItemTapped(int index) {
    final notifier = ref.read(selectedIndexProvider.notifier);
    if (index == 0) {
      final homeViewModel = ref.read(homeViewModelProvider.notifier);
      homeViewModel.fetchHotDebates();
      homeViewModel.fetchHotfighter();
      homeViewModel.hotList();
    }
    if (index == 2) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 130.h,
            margin: EdgeInsets.only(
              left: 72.w,
              right: 72.w,
              bottom: 100.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20.r),
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          context.pop();
                          context.push('/debate_create');
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/icons/bottom_plus_ai.svg'),
                            SizedBox(width: 10.w),
                            Text('토론장 개설', style: FontSystem.KR16SB),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextButton(
                        onPressed: () {
                          context.pop();
                          context.push('/ai_create');
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                                'assets/icons/bottom_plus_create.svg'),
                            SizedBox(width: 10.w),
                            Text('AI 랜덤 주제 생성기', style: FontSystem.KR16SB),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0.h,
                  child: IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
          );
        },
        backgroundColor: Colors.transparent,
      );
    } else {
      switch (index) {
        case 0:
          notifier.state = index;
          context.go('/home');
          break;
        case 1:
          notifier.state = index;
          context.go('/list');
          break;
        case 3:
          notifier.state = index;
          context.go('/myalarm');
          break;
        case 4:
          notifier.state = index;
          context.go('/mypage');
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    return BottomNavigationBar(
      backgroundColor: ColorSystem.white,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/bottom_home.svg',
            width: 24.w,
            height: 24.h,
            color: selectedIndex == 0 ? Colors.black : Colors.grey,
          ),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/bottom_list.svg',
            width: 25.w,
            height: 25.h,
            color: selectedIndex == 1 ? Colors.black : Colors.grey,
          ),
          label: '리스트',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: SvgPicture.asset(
              'assets/icons/bottom_round_purple.svg',
              width: 60.w,
              height: 60.h,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/bottom_bell.svg',
            color: selectedIndex == 3 ? Colors.black : Colors.grey,
          ),
          label: '알림',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 0.5.h),
            child: SvgPicture.asset(
              'assets/icons/bottom_my.svg',
              width: 26.w,
              height: 26.h,
              color: selectedIndex == 4 ? Colors.black : Colors.grey,
            ),
          ),
          label: '마이',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: ColorSystem.black,
      unselectedItemColor: ColorSystem.grey,
    );
  }
}

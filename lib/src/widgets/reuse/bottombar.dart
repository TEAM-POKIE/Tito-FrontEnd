import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/home_state_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
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
  // _onItemTapped을 비동기 함수로 변경
  Future<void> _onItemTapped(int index) async {
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
              bottom: 100.h,
              left: 72.w,
              right: 72.w,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20.r),
              ),
            ),
            child: Stack(
              children: [
                Column(
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
          context.push('/search');
          break;
        case 4:
          notifier.state = index;
          // 비동기 호출을 위해 await 추가
          final userInfo = await ApiService(DioClient.dio).getUserInfo();
          final loginInfoNotifier = ref.read(loginInfoProvider.notifier);
          loginInfoNotifier.setLoginInfo(userInfo);
          context.go('/mypage');
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    return Container(
      decoration: BoxDecoration(
        color: ColorSystem.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26, // 그림자 색상
            spreadRadius: 0.1,
            blurRadius: 0.1,
            offset: Offset(0, -1), // 그림자 위치 조정 (위로 약간 이동)
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
        child: BottomNavigationBar(
          backgroundColor: ColorSystem.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/bottom_home.svg',
                width: 30.w,
                height: 30.h,
                color: selectedIndex == 0 ? Colors.black : Colors.grey,
              ),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/bottom_list.svg',
                width: 30.w,
                height: 30.h,
                color: selectedIndex == 1 ? Colors.black : Colors.grey,
              ),
              label: '리스트',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: SvgPicture.asset(
                  'assets/icons/bottom_round_purple.svg',
                  width: 42.w,
                  height: 42.h,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/navi_search.svg',
                width: 30.w,
                color: selectedIndex == 3 ? Colors.black : Colors.grey,
              ),
              label: '검색',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 0.5.h),
                child: SvgPicture.asset(
                  'assets/icons/bottom_my.svg',
                  width: 30.w,
                  height: 30.h,
                  color: selectedIndex == 4 ? Colors.black : Colors.grey,
                ),
              ),
              label: '마이',
            ),
          ],
          currentIndex: selectedIndex,
          onTap: _onItemTapped, // 수정된 _onItemTapped 사용
          type: BottomNavigationBarType.fixed,
          selectedItemColor: ColorSystem.black,
          unselectedItemColor: ColorSystem.grey,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/nav_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    if (index == 2) {
      context.push('/debate_create').then((_) {});
    } else if (index == 3) {
      context.push('/ai_create').then((_) {});
    } else if (index == 4) {
      context.push('/mypage');
    } else {
      notifier.state = index;
      switch (index) {
        case 0:
          context.go('/home');
          break;
        case 1:
          context.go('/list');
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
          icon: SvgPicture.asset('assets/icons/bottom_home.svg',
            width: 24,
            height: 24,
            color: selectedIndex == 0 ? Colors.black : Colors.grey,
          ),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon:SvgPicture.asset(
            'assets/icons/bottom_list.svg',
            width: 24,
            height: 24,
            color: selectedIndex == 1 ? Colors.black : Colors.grey,
          ),
          label: '리스트',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/bottom_debate.svg',
            width: 24,
            height: 24,
          ),
          label: '토론 개설',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/bottom_ai.svg',
            width: 24,
            height: 24,
          ),
          label: 'AI 주제',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/bottom_my.svg',
            width: 24,
            height: 24,
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

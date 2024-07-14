import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/provider/nav_provider.dart';

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
    } else {
      notifier.state = index;
      switch (index) {
        case 0:
          context.go('/home');
          break;
        case 1:
          context.go('/list');
          break;
        case 4:
          context.go('/free');
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _selectedIndex = ref.watch(selectedIndexProvider.notifier).state;
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/bottombar/home.png',
            width: 24,
            height: 24,
            color: _selectedIndex == 0 ? Colors.black : null,
          ),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/bottombar/list.png',
            width: 24,
            height: 24,
            color: _selectedIndex == 1 ? Colors.black : null,
          ),
          label: '리스트',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/bottombar/create.png',
            width: 24,
            height: 24,
          ),
          label: '개설',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/bottombar/ai.png',
            width: 24,
            height: 24,
          ),
          label: 'AI 주제',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            _selectedIndex == 4
                ? 'assets/images/bottombar/board_select.png'
                : 'assets/images/bottombar/board.png',
            width: 24,
            height: 24,
          ),
          label: '게시판',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedItemColor:
          (_selectedIndex == 0 || _selectedIndex == 1 || _selectedIndex == 4)
              ? Colors.black
              : Colors.grey,
      unselectedItemColor: Colors.grey,
    );
  }
}

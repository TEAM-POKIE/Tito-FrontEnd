import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/screen/home_screen.dart';
import 'package:tito_app/screen/list_screen.dart';
import 'package:tito_app/widgets/debate/debate_create.dart';
import 'package:tito_app/widgets/ai/ai_create.dart';
import 'package:tito_app/screen/free_screen.dart';
import 'package:tito_app/provider/nav_provider.dart';

class BottomBar extends ConsumerStatefulWidget {
  const BottomBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _BottomBarState();
  }
}

class _BottomBarState extends ConsumerState<BottomBar> {
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ListScreen(),
    DebateCreate(),
    AiCreate(),
    FreeScreen(),
  ];

  void _onItemTapped(int index) {
    if (ref.read(selectedIndexProvider.notifier).state == index) return;

    if (index == 1 || index == 4) {
      ref.read(selectedIndexProvider.notifier).state = index;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => _widgetOptions[index]),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => _widgetOptions[index]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final int _selectedIndex = ref.watch(selectedIndexProvider);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
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
              'assets/images/bottombar/board.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 4 ? Colors.black : null,
            ),
            label: '게시판',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: (_selectedIndex == 1 || _selectedIndex == 4)
            ? Colors.black
            : Colors.grey,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

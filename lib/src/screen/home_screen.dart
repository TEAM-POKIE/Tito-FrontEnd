import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tito_app/core/provider/home_state_provider.dart';
import 'package:tito_app/src/view/homeVIew/home_appbar.dart';
import 'package:tito_app/src/view/homeVIew/home_view.dart';
import 'package:tito_app/src/view/homeVIew/hot_fighter.dart';
import 'package:tito_app/src/view/homeVIew/hot_lists.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DateTime? lastBackPressedTime;

  // Future<bool> _onWillPop(BuildContext context) async {
  //   if (lastBackPressedTime == null ||
  //       DateTime.now().difference(lastBackPressedTime!) >
  //           Duration(seconds: 2)) {
  //     lastBackPressedTime = DateTime.now();
  //     FlutterTo.showToast(msg: '뒤로 가기를 한번 더 누르면 종료됩니다.');
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: const HomeAppbar(),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          HomeView(), // 첫 번째 위젯
          SizedBox(height: 20.h), // 위젯 간의 간격
          HotLists(), // 두 번째 위젯
          SizedBox(height: 20.h), // 위젯 간의 간격
          HotFighter(), // 세 번째 위젯
        ],
      ),
    );
  }
}

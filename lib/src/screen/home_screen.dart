import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tito_app/src/view/homeVIew/home_appbar.dart';
import 'package:tito_app/src/view/homeVIew/home_view.dart';
import 'package:tito_app/src/view/homeVIew/hot_fighter.dart';
import 'package:tito_app/src/view/homeVIew/hot_lists.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/src/widgets/reuse/bottombar.dart';

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

  DateTime? currentBackPressTime;

  @override
  void dispose() {
    BackButtonInterceptor.remove(_interceptor);
    super.dispose();
  }

  bool _interceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;

      Fluttertoast.showToast(
        msg: "뒤로 버튼을 한 번 더 누르시면 종료됩니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
      );
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: const HomeAppbar(),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        children: [
          const HomeView(),
          SizedBox(height: 20.h),
          const HotLists(),
          SizedBox(height: 20.h),
          const HotFighter(),
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/view/homeVIew/home_appbar.dart';
import 'package:tito_app/src/view/homeVIew/home_view.dart';
import 'package:tito_app/src/view/homeVIew/hot_fighter.dart';
import 'package:tito_app/src/view/homeVIew/hot_lists.dart';
import 'package:tito_app/src/widgets/reuse/search_bar.dart';
import 'package:tito_app/core/provider/home_state_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: const HomeAppbar(),
        ),
      ),
      body:  Column(
              children: [
                CustomSearchBar(),
                HomeView(),
                HotLists(),
                HotFighter()
              ],
            ),
    //   body: homeState.isLoading
    //       ? const Center(child: SpinKitThreeBounce(
    //         color: ColorSystem.lightPurple,
    //         size: 30,
    //         duration: Duration(seconds: 2),
    //       ))
    //       : const Column(
    //           children: [
    //             CustomSearchBar(),
    //             HomeView(),
    //             HotLists(),
    //             HotFighter()
    //           ],
    //         ),
    );
  }
}

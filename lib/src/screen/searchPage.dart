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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/src/widgets/reuse/search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:go_router/go_router.dart';

class Searchpage extends ConsumerWidget {
  const Searchpage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ColorSystem.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomSearchBar(),
              ),
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('취소', style: FontSystem.KR16M),
              ),
            ],
          )),
    );
  }
}

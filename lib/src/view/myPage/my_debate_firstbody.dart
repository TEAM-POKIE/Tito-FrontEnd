import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/screen/home_screen.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tito_app/core/provider/login_provider.dart';

class MyDebateFirstbody extends ConsumerStatefulWidget {
  const MyDebateFirstbody({super.key});

  @override
  ConsumerState<MyDebateFirstbody> createState() {
    return _MyDebateFirstbodyState();
  }
}

class _MyDebateFirstbodyState extends ConsumerState<MyDebateFirstbody> {
  final List<String> sortOptions = ['최신순', '인기순'];
  String selectedSortOption = '최신순';

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedSortOption = sortOptions[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginInfo = ref.watch(loginInfoProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Column(
            children: [
              Row(
                children: [
                  Text('${loginInfo?.nickname}',
                        style: FontSystem.KR20B
                      ),
                  const Text(
                    ' 님은 12번의 토론 중',
                    style: FontSystem.KR20R,
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    '10번을 이기셨어요!',
                    style: FontSystem.KR20R,
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: DropdownButton<String>(
                value: selectedSortOption,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSortOption = newValue!;
                  });
                },
                items:
                    sortOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: FontSystem.KR14R
                          .copyWith(color: ColorSystem.grey), // 글자 크기 설정
                    ),
                  );
                }).toList(),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: ColorSystem.grey,
                  size: 20.sp,
                ),
                underline: SizedBox.shrink(),
                style: FontSystem.KR14R.copyWith(color: ColorSystem.grey),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

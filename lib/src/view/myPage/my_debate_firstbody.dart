import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/screen/home_screen.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: const Text(
            '포키님은 12번의 토론 중\n10번을 이기셨어요!',
            style: FontSystem.KR20R,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: DropdownButton2<String>(
                value: selectedSortOption,
                underline: SizedBox.shrink(), // 밑줄 제거
                // icon: Icon(Icons.keyboard_arrow_down_sharp),
                // dropdownDecoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(12.0), // 모서리를 둥글게 설정
                //   color: ColorSystem.ligthGrey,
                // ),
                // menuMaxHeight: 200.0, // 드롭다운 메뉴 최대 높이 설정
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSortOption = newValue!;
                  });
                },
                items:
                    sortOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Column(
                      children: [
                        Text(
                          value,
                          style: FontSystem.KR14R, // 글자 크기 설정
                        ),
                        if (value != sortOptions.last)
                          Divider(color: ColorSystem.grey), // 구분선 추가
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

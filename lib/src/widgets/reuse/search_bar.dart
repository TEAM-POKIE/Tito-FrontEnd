import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/constants/style.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 310.w,
        height: 50.h,
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: SvgPicture.asset(
                'assets/icons/search_size_four.svg',
              ),
            ),
            filled: true,
            fillColor: ColorSystem.ligthGrey, // 더 밝은 배경색
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24.r),
                borderSide: BorderSide.none),
            hintText: '카테고리, 제목, 내용',
            hintStyle: FontSystem.KR16M.copyWith(color: ColorSystem.grey),
          ),
          style: const TextStyle(
            color: ColorSystem.black,
          ),
        ),
      ),
    );
  }
}

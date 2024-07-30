import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 350.w,
        height: 50.h,
        child: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: ColorSystem.ligthGrey, // 더 밝은 배경색
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24.r),
                borderSide: BorderSide.none),
            hintText: '검색어를 입력하세요',
            hintStyle: const TextStyle(
              fontSize: 16,
              color: ColorSystem.grey,
            ),
            prefixIcon: const Icon(Icons.search,
                color: ColorSystem.grey,
                size: 26.0), // 아이콘 색상 추가
          ),
          style: const TextStyle(
            color: ColorSystem.black,
          ),
        ),
      ),
    );
  }
}

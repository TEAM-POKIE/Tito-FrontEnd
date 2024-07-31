import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tito_app/src/widgets/ai/ai_select.dart';
import 'package:get/get.dart';
import 'package:tito_app/src/widgets/ai/selection_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/constants/style.dart';

class AiCreate extends StatelessWidget {
  SelectionController selectionController = Get.put(SelectionController());

  AiCreate({super.key});

  Widget _buildGridItem(BuildContext context, String text, int index) {
    return Obx(() {
      bool isSelected = selectionController.selectedItems.contains(index);
      return InkWell(
        onTap: () => selectionController.toggleSelection(index),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: isSelected ? ColorSystem.purple : ColorSystem.grey),
            borderRadius: BorderRadius.circular(24.r),
          ),
          margin: EdgeInsets.all(4.5.w),
          child: Center(
            child: Text(text),
          ),
        ),
      );
    });
  }

  Widget _buildSelectedItem(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Transform.scale(
        scale: 0.8,
        child: Container(
          width: 120.w,
          height: 50.h,
          child: Chip(
            label: Text(
              '아이템 $index',
              style: TextStyle(color: ColorSystem.white, fontSize: 14.sp),
            ),
            backgroundColor: Colors.black,
            deleteIcon: const Icon(
              Icons.close,
              color: ColorSystem.white,
              size: 20,
            ),
            onDeleted: () => selectionController
                .toggleSelection(index), // X 아이콘이 눌렸을 때 선택 상태 토글
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 37.h,
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: 10.w)),
                SvgPicture.asset(
                  'assets/icons/purple_cute.svg',
                  width: 40.w,
                  height: 40.h,
                ),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    const Text(
                      'AI 자동 토론 주제 생성 하기',
                      style: FontSystem.KR18R,
                    ),
                    SizedBox(height: 8.h),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '원하는 키워드를 선택해보세요!',
                          style: FontSystem.KR18R,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 61.h,
            child: Obx(() {
              return selectionController.selectedItems.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 0.0, // Chip 간의 수평 간격 최소화
                          runSpacing: 0.0, // Chip 줄 간의 수직 간격 최소화
                          children: selectionController.selectedItems
                              .map((index) => _buildSelectedItem(index))
                              .toList(),
                        ),
                      ),
                    )
                  : Container();
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: TextButton(
                  onPressed: selectionController.resetSelection,
                  child: Text(
                    '새로고침',
                    style: TextStyle(
                        color: ColorSystem.black,
                        fontSize: 14.sp,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30.h,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                width: 330.w,
                height: 250.h,
                child: GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(9, (index) {
                    return _buildGridItem(context, '아이템 $index', index);
                  }),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
            child: Obx(() {
              bool isSelectExist = selectionController.selectedItems.isNotEmpty;
              return SizedBox(
                width: 350.w,
                height: 60.h,
                child: ElevatedButton(
                  onPressed: isSelectExist
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AiSelect()),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r)),
                    backgroundColor:
                        isSelectExist ? ColorSystem.purple : ColorSystem.grey,
                  ),
                  child: Text(
                    '다음',
                    style: TextStyle(color: ColorSystem.white, fontSize: 20.sp),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

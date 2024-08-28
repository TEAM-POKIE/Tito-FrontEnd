import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/ai_provider.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AiCreate extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectionState = ref.watch(selectionProvider);
    final selectionNotifier = ref.read(selectionProvider.notifier);

    Widget _buildGridItem(BuildContext context, String text, int index) {
      bool isSelected = selectionState.selectedItems.contains(index);
      return GestureDetector(
        onTap: () => selectionNotifier.toggleSelection(index),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: isSelected ? ColorSystem.purple : ColorSystem.grey,
                width: isSelected ? 2.0 : 1.0),
            borderRadius: BorderRadius.circular(10.r),
          ),
          margin: EdgeInsets.all(4.5.w),
          child: Center(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: FontSystem.KR20M,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              AppBar(
                backgroundColor: ColorSystem.white,
                leading: IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: SvgPicture.asset('assets/icons/back_arrow.svg'),
                ),
              ),
              SizedBox(height: 58.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10.w)),
                  SvgPicture.asset(
                    'assets/icons/purple_cute.svg',
                    width: 40.w,
                    height: 40.h,
                  ),
                  SizedBox(width: 3.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Text(
                        'AI 자동 토론 주제 생성 하기',
                        style: FontSystem.KR22SB,
                      ),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 3.w),
                    Text('원하는 키워드를 선택해보세요 !', style: FontSystem.KR20SB),
                  ],
                ),
              ),
              Container(
                height: 60.h,
                child: selectionState.selectedItems.isNotEmpty
                    ? Padding(
                        padding:
                            EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ListView(
                            controller: ScrollController(),
                            scrollDirection: Axis.horizontal,
                            children: selectionState.selectedItems
                                .map((index) => _buildSelectedItem(index))
                                .toList(),
                          ),
                        ),
                      )
                    : Container(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          '새로고침',
                          style: FontSystem.KR16SB
                              .copyWith(decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    width: 350.w,
                    height: 258.h,
                    child: GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: 1.3 / 1,
                      children: List.generate(9, (index) {
                        return _buildGridItem(context, '원숭이다리', index);
                      }),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: SizedBox(
                  width: 350.w,
                  height: 60.h,
                  child: ElevatedButton(
                    onPressed: selectionState.selectedItems.isNotEmpty
                        ? () async {
                            await selectionNotifier.createSelection();
                            if (!selectionState.isLoading) {
                              context.push('/ai_select');
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      backgroundColor: selectionState.selectedItems.isNotEmpty
                          ? ColorSystem.purple
                          : ColorSystem.grey,
                    ),
                    child: Text(
                      '다음',
                      style:
                          TextStyle(color: ColorSystem.white, fontSize: 20.sp),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (selectionState.isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitThreeBounce(
                      color: ColorSystem.grey3,
                      size: 30.sp,
                      duration: Duration(seconds: 2),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'AI 주제 생성 중',
                      style:
                          FontSystem.KR18SB.copyWith(color: ColorSystem.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSelectedItem(int index) {
    return GestureDetector(
      onTap: () {
        _scrollToItem(index);
      },
      child: Container(
        key: GlobalKey(),
        height: 30.h,
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        child: Chip(
          label: Text(
            '$index 원숭이다리',
            style: FontSystem.KR14M.copyWith(color: ColorSystem.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          backgroundColor: Colors.black,
          deleteIcon: const Icon(
            Icons.close,
            color: ColorSystem.white,
            size: 20,
          ),
          onDeleted: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }

  void _scrollToItem(int index) {}
}

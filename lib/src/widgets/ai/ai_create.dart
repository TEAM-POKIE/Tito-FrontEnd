import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tito_app/src/widgets/ai/ai_select.dart';
import 'package:get/get.dart';
import 'package:tito_app/src/widgets/ai/selection_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/widgets/reuse/bottombar.dart';

class AiCreate extends StatelessWidget {
  SelectionController selectionController = Get.put(SelectionController());
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _itemKeys = {};

  AiCreate({super.key});

  Widget _buildGridItem(BuildContext context, String text, int index) {
    return Obx(() {
      bool isSelected = selectionController.selectedItems.contains(index);
      return GestureDetector(
        onTap: () => selectionController.toggleSelection(index),
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
    });
  }

  Widget _buildSelectedItem(int index) {
    // 각 아이템마다 고유한 GlobalKey를 부여해서 각 아이템 크기 계산하기
    if (!_itemKeys.containsKey(index)) {
      _itemKeys[index] = GlobalKey();
    }
    return GestureDetector(
      onTap: () {
        _scrollToItem(index);
      },
      child: Container(
        key: _itemKeys[index],

        height: 30.h,
        margin: EdgeInsets.symmetric(horizontal: 3.w), // chip 간의 간격 조절
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
          onDeleted: () => selectionController
              .toggleSelection(index), // X 아이콘이 눌렸을 때 선택 상태 토글
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }

  void _scrollToItem(int index) {
    final key = _itemKeys[index];
    if (key == null) return;

    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.5, // 중앙에 위치하도록 조정
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 58.h,
          ),
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
                  const Text(
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
                const Text('원하는 키워드를 선택해보세요 !', style: FontSystem.KR20SB),
              ],
            ),
          ),
          Container(
            height: 60.h,
            child: Obx(() {
              return Container(
                child: selectionController.selectedItems.isNotEmpty
                    ? Padding(
                        padding:
                            EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ListView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal, // 가로로 스크롤 가능하게 설정
                            children: selectionController.selectedItems
                                .map((index) => _buildSelectedItem(index))
                                .toList(),
                          ),
                        ),
                      )
                    : Container(),
              );
            }),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: TextButton(
                    onPressed: selectionController.resetSelection,
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
          SizedBox(
            height: 20.h,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                width: 350.w,
                height: 258.h,
                child: GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 1.3 / 1, // 아이템의 가로:세로 비율을 2:1로 설정 (직사각형)
                  children: List.generate(9, (index) {
                    return _buildGridItem(context, '원숭이다리', index);
                  }),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Obx(() {
              bool isSelectExist = selectionController.selectedItems.isNotEmpty;
              return SizedBox(
                width: 350.w,
                height: 60.h,
                child: ElevatedButton(
                  onPressed: isSelectExist
                      ? () {
                          context.push('/ai_select');
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
      bottomNavigationBar: BottomBar(),
    );
  }
}

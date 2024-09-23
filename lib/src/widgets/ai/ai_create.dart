import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/ai_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AiCreate extends ConsumerStatefulWidget {
  @override
  _AiCreateState createState() => _AiCreateState();
}

class _AiCreateState extends ConsumerState<AiCreate> {
  @override
  void initState() {
    super.initState();
    final selectionNotifier = ref.read(selectionProvider.notifier);
    selectionNotifier.getWord();
  }

  @override
  Widget build(BuildContext context) {
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
                scrolledUnderElevation: 0,
                backgroundColor: ColorSystem.white,
                leading: IconButton(
                  onPressed: () {
                    context.pop();
                    selectionNotifier.resetSelection();
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
                                .map((index) => _buildSelectedItem(index,
                                    selectionState.randomWord[index].word))
                                .toList(),
                          ),
                        ),
                      )
                    : Container(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      selectionNotifier.resetSelection(); // 인덱스 초기화
                      selectionNotifier.getWord(); // 새로운 단어 가져오기
                    },
                    child: Text(
                      '새로고침',
                      style: FontSystem.KR16SB
                          .copyWith(decoration: TextDecoration.underline),
                    ),
                  ),
                  Container(
                    width: 350.w,
                    height: 330.h,
                    child: GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: 1.3 / 1,
                      physics: NeverScrollableScrollPhysics(), // 스크롤 비활성화
                      children: List.generate(9, (index) {
                        String word = selectionState.randomWord != null &&
                                selectionState.randomWord.length > index
                            ? selectionState.randomWord[index].word
                            : '로딩 중...'; // 단어가 없는 경우 로딩 메시지 표시
                        return _buildGridItem(context, word, index);
                      }),
                    ),
                  ),
                ],
              ),
              const Spacer(),
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
                              selectionNotifier.resetSelection();
                              context.push('/ai_select');
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        backgroundColor: ColorSystem.purple),
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

  Widget _buildSelectedItem(int index, String word) {
    final selectionNotifier = ref.read(selectionProvider.notifier);
    return GestureDetector(
      onTap: () {},
      child: Container(
        key: GlobalKey(),
        height: 30.h,
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        child: Chip(
          label: Text(
            word,
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
          onDeleted: () {
            selectionNotifier.toggleSelection(index);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}

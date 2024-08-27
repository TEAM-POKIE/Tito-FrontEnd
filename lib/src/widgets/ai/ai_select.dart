import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tito_app/core/provider/ai_provider.dart';

import 'package:go_router/go_router.dart';

class AiSelect extends ConsumerWidget {
  AiSelect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectionState = ref.watch(selectionProvider);
    final hasSelection = selectionState.topics.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSystem.white,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: SvgPicture.asset('assets/icons/back_arrow.svg'),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 37.h),
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/purple_cute.svg',
                  width: 40.w,
                  height: 40.h,
                ),
                SizedBox(width: 3.w),
                Text(
                  'AI 자동 토론 주제 생성 하기',
                  style: FontSystem.KR22SB,
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.only(left: 23.w),
            child: Text('이런 주제는 어때요?', style: FontSystem.KR20SB),
          ),
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.only(left: 23.w),
            child: Text('바로 다른 사람들과 의견을 나눠보세요!', style: FontSystem.KR20SB),
          ),
          SizedBox(height: 60.h), // 간격 추가
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 5.0,
                radius: Radius.circular(20.r),
                child: ListView.builder(
                  itemCount: selectionState.topics.length,
                  itemBuilder: (context, index) {
                    final topic = selectionState.topics[index];
                    final isExpanded = selectionState.expandedIndex == index;

                    return GestureDetector(
                      onTap: () {
                        ref
                            .read(selectionProvider.notifier)
                            .toggleExpandedIndex(index);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.h, horizontal: 20.w),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 150),
                          curve: Curves.linear,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isExpanded
                                  ? ColorSystem.purple
                                  : ColorSystem.grey,
                              width: isExpanded ? 2.0 : 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          height: isExpanded ? 250 : null,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20.h, horizontal: 10.w),
                                child: Text(
                                  topic.topic,
                                  style: isExpanded
                                      ? FontSystem.KR20SB
                                      : FontSystem.KR20M,
                                  softWrap: true, // 자동 줄바꿈 설정
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                              if (isExpanded)
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/icons/ai_opinion.svg'),
                                          SizedBox(width: 5.w),
                                          Expanded(
                                            child: Text(
                                              topic.a,
                                              style: FontSystem.KR16SB,
                                              softWrap: true, // 자동 줄바꿈 설정
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 6.h),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/icons/ai_opinion.svg'),
                                          SizedBox(width: 5.w),
                                          Expanded(
                                            child: Text(
                                              topic.b,
                                              style: FontSystem.KR16SB,
                                              softWrap: true, // 자동 줄바꿈 설정
                                              overflow: TextOverflow
                                                  .visible, // 텍스트가 넘칠 때 처리
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 20.w, right: 20.w, bottom: 20.h, top: 40.h),
            child: SizedBox(
              width: 350.w,
              height: 60.h,
              child: ElevatedButton(
                onPressed: hasSelection
                    ? () {
                        context.push('/debate_create');
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      hasSelection ? ColorSystem.purple : ColorSystem.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                child: Text(
                  '토론 생성',
                  style: TextStyle(color: ColorSystem.white, fontSize: 20.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

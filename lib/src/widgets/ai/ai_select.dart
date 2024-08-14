import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tito_app/src/widgets/ai/ai_select.dart';
import 'package:get/get.dart';
import 'package:tito_app/src/widgets/ai/selection_controller.dart';
import 'package:go_router/go_router.dart';

class AiSelect extends StatefulWidget {
  //AiSelect({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AiSelectState();
  }
}

class _AiSelectState extends State<AiSelect> {
  int expandedIndex = -1; //초기 상태에는 아무 항목도 확장되지 않도록 하기

  @override
  Widget build(BuildContext context) {
    bool hasSelection = expandedIndex != -1;

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
          SizedBox(
            height: 37.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/purple_cute.svg',
                  width: 40.w,
                  height: 40.h,
                ),
                SizedBox(
                  width: 3.w,
                ),
                Text(
                  'AI 자동 토론 주제 생성 하기',
                  style: FontSystem.KR22SB,
                ),
              ],
            ),
          ),

          SizedBox(
            height: 8.h,
          ),

          Padding(
            padding: EdgeInsets.only(left: 23.w),
            child: Text('이런 주제는 어때요?', style: FontSystem.KR20SB),
          ),
          SizedBox(
            height: 1.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 23.w),
            child:
                Text('바로 다른 사람들과 의견을 나눠보세요 !', style: FontSystem.KR20SB),
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
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      bool isExpanded = expandedIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            expandedIndex =
                                isExpanded ? -1 : index; // 클릭한 항목 확장 또는 축소
                          });
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
                                  child: Expanded(
                                    child: Text(
                                      '긴 제목으로 테스트를 해보기 위한 주제선정중이다 $index',
                                      style: isExpanded
                                          ? FontSystem.KR20SB
                                          : FontSystem.KR20M,
                                      softWrap: true, // 자동 줄바꿈 설정
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ),
                                if (isExpanded)
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                  '이것도 길때 과연 이 컨테이너 박스가 유동적으로 움직일 수 있을지!!! 시험하고 있지롱',
                                                  style: FontSystem.KR16SB,
                                                  softWrap: true, // 자동 줄바꿈 설정
                                                  overflow:
                                                      TextOverflow.visible,
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
                                                  '과연 긴 의견이 있을때는 어떻게 보여질지 테스트하기 위한 장문의견을 작성함',
                                                  style: FontSystem.KR16SB,
                                                  softWrap: true, // 자동 줄바꿈 설정
                                                  overflow: TextOverflow
                                                      .visible, // 텍스트가 넘칠 때 어떻게 처리할지 설정
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
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
                onPressed: () {
                  context.push('/debate_create');
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        hasSelection ? ColorSystem.purple : ColorSystem.grey,
                    // backgroundColor:
                    //     isSelectExist ? ColorSystem.purple : ColorSystem.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r))),
                child: Text(
                  '토론 생성',
                  style: TextStyle(color: ColorSystem.white, fontSize: 20.sp),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/debate_create_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DebateCreate extends ConsumerStatefulWidget {
  const DebateCreate({super.key});

  @override
  ConsumerState<DebateCreate> createState() => _DebateCreateState();
}

class _DebateCreateState extends ConsumerState<DebateCreate> {
  final _formKey = GlobalKey<FormState>();
  int categorySelectedIndex = 0;
  int _currentPage = 0;
  final int _totalPages = 3;

  void _goNextCreate() async {
    final debateViewModel = ref.watch(debateCreateProvider.notifier);
    final viewModel = ref.read(debateCreateProvider.notifier);
    if (!viewModel.validateForm(_formKey)) {
      return;
    }
    viewModel.saveForm(_formKey);
    debateViewModel.updateCategory(categorySelectedIndex);
    if (!context.mounted) return;

    //현재 위젯의 context가 여전히 트리에서 유효한 상태인지 확인하는 것이다. 트리에 없는 상태라면 더 이상 진행하지 않고 함수 실행을 종료한다.
    context.push('/debate_create_second');
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(debateCreateProvider.notifier);

    double _progress = (_currentPage + 1) / _totalPages;

    final List<String> labels = ['연애', '정치', '연예', '자유', '스포츠'];

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss keyboard
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorSystem.white,
          leading: IconButton(
            onPressed: () {
              //debateState.debateContent = '';
              context.pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 24.w),
                  child: LinearPercentIndicator(
                    width: 210.w,
                    animation: true,
                    animationDuration: 1000,
                    lineHeight: 5.0,
                    percent: _progress,
                    linearStrokeCap: LinearStrokeCap.butt,
                    progressColor: ColorSystem.purple,
                    backgroundColor: ColorSystem.grey,
                    barRadius: Radius.circular(10.r),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: const Text(
                    '카테고리 선택',
                    style: FontSystem.KR18SB,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Container(
                    //카테고리 바가 들어가는 Container 부분
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal, // 수평 스크롤 가능하게 설정
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(labels.length, (index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: Container(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    categorySelectedIndex = index;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      categorySelectedIndex == index
                                          ? ColorSystem.black
                                          : ColorSystem.ligthGrey,
                                  foregroundColor:
                                      categorySelectedIndex == index
                                          ? ColorSystem.white
                                          : ColorSystem.grey1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                    side: BorderSide(
                                      color: categorySelectedIndex == index
                                          ? ColorSystem.black // 선택된 경우 테두리 색상
                                          : ColorSystem
                                              .grey3, // 선택되지 않은 경우 테두리 색상
                                      width: 1.5, // 테두리 두께
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      labels[index],
                                      style: categorySelectedIndex == index
                                          ? FontSystem.KR14SB.copyWith(
                                              color: ColorSystem.white)
                                          : FontSystem.KR14M.copyWith(
                                              color: ColorSystem.grey1,
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
                ),
                SizedBox(
                  height: 60.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: const Text(
                    '토론 주제',
                    style: FontSystem.KR18SB,
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: TextFormField(
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: '입력하세요',
                      fillColor: ColorSystem.ligthGrey,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '주제를 입력하세요';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      viewModel.updateTitle(value ?? '');
                    },
                  ),
                ),
                SizedBox(height: 30.h),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: SvgPicture.asset(
                          'assets/icons/purple_cute.svg',
                          width: 30.w,
                          height: 30.h,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.push('/ai_create');
                        },
                        child: Text(
                          'AI 자동 주제 생성 하기',
                          style: FontSystem.KR18B.copyWith(
                              color: ColorSystem.purple,
                              decoration: TextDecoration.underline,
                              decorationColor: ColorSystem.purple),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          child: SizedBox(
            width: 350.w,
            height: 60.h,
            child: ElevatedButton(
              onPressed: _goNextCreate,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorSystem.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              child: Text(
                '다음',
                style: TextStyle(fontSize: 20.sp, color: ColorSystem.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
  int _currentPage = 0;
  final int _totalPages = 3;

  void _nextPage() {
    setState(() {
      if (_currentPage < _totalPages - 1) {
        _currentPage++;
      }
    });
  }

  void _previousPage() {
    setState(() {
      if (_currentPage > 0) {
        _currentPage--;
      }
    });
  }

  void _goNextCreate() async {
    final viewModel = ref.read(debateCreateProvider.notifier);

    if (!viewModel.validateForm(_formKey)) {
      return;
    }

    viewModel.saveForm(_formKey);

    if (!context.mounted) return;

    context.push('/debate_create_second');
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(debateCreateProvider.notifier);
    final debateState = ref.watch(debateCreateProvider);
    double _progress = (_currentPage + 1) / _totalPages;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss keyboard
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorSystem.white,
          leading: IconButton(
            onPressed: () {
              debateState.debateContent = '';
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
                    style: FontSystem.KR18R,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Container(
                    width: 380.w,
                    height: 30.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(viewModel.labels.length, (index) {
                        return Container(
                          height: 30.h,
                          width: 75.w,
                          child: ElevatedButton(
                            onPressed: () {
                              viewModel.updateCategory(index);
                            },
                            style: ElevatedButton.styleFrom(
                              textStyle: FontSystem.KR10R,
                              padding: const EdgeInsets.all(0),
                              backgroundColor: debateState.debateCategory ==
                                      viewModel.labels[index]
                                  ? ColorSystem.black
                                  : Colors.grey[200],
                              foregroundColor: debateState.debateCategory ==
                                      viewModel.labels[index]
                                  ? ColorSystem.white
                                  : const Color.fromARGB(255, 101, 101, 101),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  viewModel.labels[index],
                                  style: TextStyle(fontSize: 10.sp),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
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
                    style: FontSystem.KR18R,
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
                        borderRadius: BorderRadius.circular(24.r),
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
                          context.go('/ai_create');
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

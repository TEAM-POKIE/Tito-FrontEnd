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
          leading: IconButton(
            onPressed: () {
              context.pop();
              //바로 이전에 실행했던 화면으로 이동
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40.h),
                  const Text(
                    '카테고리 선택',
                    style: FontSystem.KR18R,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(viewModel.labels.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: SizedBox(
                          width: (MediaQuery.of(context).size.width - 80) * 0.2,
                          child: ElevatedButton(
                            onPressed: () {
                              viewModel.updateCategory(index);
                            },
                            style: ElevatedButton.styleFrom(
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              padding: const EdgeInsets.all(0),
                              backgroundColor: debateState.debateCategory ==
                                      viewModel.labels[index]
                                  ? ColorSystem.black
                                  : ColorSystem.ligthGrey,
                              foregroundColor: debateState.debateCategory ==
                                      viewModel.labels[index]
                                  ? Colors.white
                                  : const Color(0xff6B6B6B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            child: Text(
                              viewModel.labels[index],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(
                    height: 60.h,
                  ),
                  const Text(
                    '토론 주제',
                    style: FontSystem.KR18R,
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
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
                  SizedBox(height: 30.h),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 7.w),
                          child: SvgPicture.asset(
                            'assets/icons/purple_cute.svg',
                            width: 40.w,
                            height: 40.h,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go('/ai_create');
                          },
                          child: Text(
                            'AI 자동 주제 생성 하기',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: ColorSystem.purple,
                                color: ColorSystem.purple,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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

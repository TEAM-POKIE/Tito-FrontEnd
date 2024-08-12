import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tito_app/core/provider/debate_create_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_svg/flutter_svg.dart';


class DebateCreateSecond extends ConsumerStatefulWidget {
  const DebateCreateSecond({super.key});

  @override
  ConsumerState<DebateCreateSecond> createState() => _DebateCreateSecondState();
}

class _DebateCreateSecondState extends ConsumerState<DebateCreateSecond> {
  final _formKey = GlobalKey<FormState>();
  String aArgument = '';
  String bArgument = '';
  int _currentPage = 1;
  final int _totalPages = 3;
  double _progress = 0.0;

  void updateProgress(int _currentPage) {
    // 각 페이지에 대한 진행률 범위 설정
    List<double> progressRanges = [
      0.0, 0.3, // 첫 번째 페이지: 0% ~ 30%
      0.3, 0.6, // 두 번째 페이지: 30% ~ 60%
      0.6, 0.9, // 세 번째 페이지: 60% ~ 90%
      0.9, 1.0 // 네 번째 페이지: 90% ~ 100%
    ];

    // 현재 페이지의 시작과 끝 범위를 가져옵니다.
    double startRange = progressRanges[_currentPage * 2];
    double endRange = progressRanges[_currentPage * 2 + 1];

    // 현재 페이지에서의 진행률 계산
    double pageProgress =
        (endRange - startRange) * ((_currentPage + 1) / _totalPages);

    // 전체 진행률로 변환
    _progress = startRange + pageProgress;

    // 진행 상황 업데이트
    setState(() {
      _progress = _progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    final debateViewModel = ref.read(debateCreateProvider.notifier);
    final debateState = ref.watch(debateCreateProvider);
    double _progress = (_currentPage + 1) / _totalPages;

    void _nextCreate(BuildContext context) async {
      if (!debateViewModel.validateForm(_formKey)) {
        return;
      }
      _formKey.currentState?.save(); // 폼의 모든 필드 저장
      print('aArgument: $aArgument');
      print('bArgument: $bArgument');
      debateViewModel.updateOpinion(aArgument, bArgument);

      if (!context.mounted) return;

      context.push('/debate_create_third');
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 키보드 내리기
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorSystem.white,
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: SvgPicture.asset('assets/icons/back_arrow.svg'),
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
                    percent: 0.5,
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
                  SizedBox(height: 34.h),
                  Text(
                    debateState.debateTitle,
                    style: FontSystem.KR18B.copyWith(fontSize: 30),
                  ),
                  SizedBox(height: 40.h),
                  const Text(
                    '나의 주장',
                    style: FontSystem.KR18SB,
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
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
                        return '나의 주장을 입력하세요';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      aArgument = value ?? '';
                    },
                  ),
                  SizedBox(height: 40.h),
                  const Text(
                    '상대 주장',
                    style: FontSystem.KR18SB,
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
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
                        return '상대 주장을 입력하세요';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      bArgument = value ?? '';
                    },
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
              onPressed: () => _nextCreate(context),
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

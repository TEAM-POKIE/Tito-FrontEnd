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
  late TextEditingController _aController;
  late TextEditingController _bController;
  String aArgument = '';
  String bArgument = '';
  int _currentPage = 1;
  final int _totalPages = 3;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    final debateState = ref.read(debateCreateProvider);
    // debateState.debateTitle 값을 초기값으로 설정
    _aController = TextEditingController(text: debateState.debateMakerOpinion);
    _bController = TextEditingController(text: debateState.debateJoinerOpinion);
  }

  @override
  void dispose() {
    _aController.dispose(); // 컨트롤러는 더 이상 필요하지 않으면 해제
    _bController.dispose(); // 컨트롤러는 더 이상 필요하지 않으면 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final debateViewModel = ref.read(debateCreateProvider.notifier);
    final debateState = ref.watch(debateCreateProvider);

    void _nextCreate(BuildContext context) async {
      if (!debateViewModel.validateForm(_formKey)) {
        return;
      }
      _formKey.currentState?.save();

      debateViewModel.updateOpinion(aArgument, bArgument);

      if (!context.mounted) return;
      final progressNotifier = ref.read(progressProvider.notifier);
      progressNotifier.incrementProgress();
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 키보드 내리기
      },
      child: Scaffold(
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
                  Text(
                    '나의 주장',
                    style: FontSystem.KR18SB,
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: _aController,
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
                  Text(
                    '상대 주장',
                    style: FontSystem.KR18SB,
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: _bController,
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

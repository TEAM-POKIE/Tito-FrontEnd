import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/debate_create_provider.dart';
import 'package:tito_app/src/screen/debate/debate_create_screen.dart';
import 'package:tito_app/src/screen/debate/debate_create_second.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/src/screen/debate/debate_create_third.dart';
import 'package:tito_app/src/widgets/ai/ai_select.dart';

import 'package:go_router/go_router.dart';

class DebateBody extends ConsumerStatefulWidget {
  const DebateBody({super.key});

  @override
  ConsumerState<DebateBody> createState() => _DebateBodyState();
}

class _DebateBodyState extends ConsumerState<DebateBody> {
  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(progressProvider);
    final progressNoti = ref.watch(progressProvider.notifier);
    final debateState = ref.watch(debateCreateProvider);

    Widget displayedWidget;

    switch (progress) {
      case 0.33:
        displayedWidget = DebateCreateScreen();
        break;
      case 0.66:
        displayedWidget = DebateCreateSecond();
        break;
      // 필요한 경우 추가적으로 다른 progress 값에 따라 다른 위젯을 추가할 수 있습니다.
      default:
        displayedWidget = DebateCreateThird(); // 기본값으로 첫 화면을 보여줌
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          backgroundColor: ColorSystem.white,
          leading: IconButton(
            onPressed: () {
              if (progress == 0.33) {
                debateState.debateContent = '';
                debateState.debateTitle = '';
                debateState.debateMakerOpinion = '';
                debateState.debateJoinerOpinion = '';
                debateState.debateImageUrl = '';
                context.pop();
              }
              progressNoti.decreaseProgress();
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
                    animateFromLastPercent: true,
                    animationDuration: 1000,
                    lineHeight: 5.0,
                    percent: progress,
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
      ),
      body: displayedWidget,
    );
  }
}

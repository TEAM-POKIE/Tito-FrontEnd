import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/provider/ended_provider.dart';

class EndedVotingbar extends ConsumerStatefulWidget {
  const EndedVotingbar({super.key});

  @override
  _VotingBarState createState() => _VotingBarState();
}

class _VotingBarState extends ConsumerState<EndedVotingbar> {
  @override
  Widget build(BuildContext context) {
    final endedState = ref.watch(endedProvider);

    final percent = (endedState?.ownerVoteRate == 0)
        ? 0.5
        : (endedState?.joinerVoteRate ?? 0) / 100.0;

    return LinearPercentIndicator(
      lineHeight: 30.0,
      animation: true,
      padding: EdgeInsets.zero,
      animationDuration: 500,
      animateFromLastPercent: true,
      percent: percent,
      linearStrokeCap: LinearStrokeCap.roundAll,
      progressColor: ColorSystem.voteBlue,
      backgroundColor: ColorSystem.voteRed,
      center: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${(percent * 100).toStringAsFixed(1)}%", // 퍼센트 텍스트 추가
              style: FontSystem.KR14SB.copyWith(
                color: ColorSystem.white,
              ),
            ),
            Text(
              "${(100.0 - (percent * 100)).toStringAsFixed(1)}%", // 퍼센트 텍스트 추가
              style: FontSystem.KR14SB.copyWith(
                color: ColorSystem.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

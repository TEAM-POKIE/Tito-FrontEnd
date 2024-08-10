import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/voting_provider.dart';

class VotingBar extends HookConsumerWidget {
  const VotingBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voteState = ref.watch(voteProvider);

    // 이전의 퍼센트 값 유지

    return LinearPercentIndicator(
      lineHeight: 6.0,
      animation: true,
      padding: EdgeInsets.zero,
      animationDuration: 500,
      animateFromLastPercent: true, // 마지막 퍼센트에서 애니메이션 시작
      percent: voteState.bluePercent,
      linearStrokeCap: LinearStrokeCap.roundAll,
      progressColor: ColorSystem.voteBlue,
      backgroundColor: ColorSystem.voteRed,

      // Row(
      //   children: [
      //     ElevatedButton(
      //       onPressed: () {
      //         voteNotifier.voteBlue();
      //       },
      //       child: Text('Vote Blue'),
      //     ),
      //     ElevatedButton(
      //       onPressed: () {
      //         voteNotifier.voteRed();
      //       },
      //       child: Text('Vote Red'),
      //     ),
      //   ],
      // ),
    );
  }
}

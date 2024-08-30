import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:tito_app/core/provider/live_webSocket_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/voting_provider.dart';
import 'dart:convert';

class VotingBar extends ConsumerStatefulWidget {
  const VotingBar({super.key});

  @override
  _VotingBarState createState() => _VotingBarState();
}

class _VotingBarState extends ConsumerState<VotingBar> {
  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatInfoProvider);
    final voteState = ref.watch(voteProvider);
    chatState!.bluePercent = voteState.bluePercent;
    return LinearPercentIndicator(
      lineHeight: 6.0,
      animation: true,
      padding: EdgeInsets.zero,
      animationDuration: 500,
      animateFromLastPercent: true, // 마지막 퍼센트에서 애니메이션 시작
      percent: chatState.bluePercent,
      linearStrokeCap: LinearStrokeCap.roundAll,
      progressColor: ColorSystem.voteBlue,
      backgroundColor: ColorSystem.voteRed,
    );
  }
}

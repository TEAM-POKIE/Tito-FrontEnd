import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:tito_app/core/provider/live_webSocket_provider.dart';
import 'package:tito_app/core/provider/voting_provider.dart';

class Joinervotingbar extends ConsumerStatefulWidget {
  const Joinervotingbar({super.key});

  @override
  _VotingBarState createState() => _VotingBarState();
}

class _VotingBarState extends ConsumerState<Joinervotingbar> {
  StreamSubscription<Map<String, dynamic>>? _subscription;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _subscribeToMessages();
    });
  }

  void _subscribeToMessages() {
    final webSocketService = ref.read(liveWebSocketProvider);
    final voteViewModel = ref.watch(voteProvider.notifier);
    final chatState = ref.watch(chatInfoProvider);

    _subscription = webSocketService.stream.listen((message) {
      if (message['command'] == "VOTE_RATE_RES") {
        final newBlueVotes = message["ownerVoteRate"];
        final newRedVotes = message["joinerVoteRate"];
        voteViewModel.updateVotes(newRedVotes, newBlueVotes);

        return;
      }
    });
  }

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
      percent: 1.0 - chatState.bluePercent,
      linearStrokeCap: LinearStrokeCap.roundAll,
      progressColor: ColorSystem.voteBlue,
      backgroundColor: ColorSystem.voteRed,
    );
  }
}

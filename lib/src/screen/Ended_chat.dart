import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';

import 'package:tito_app/src/view/chatView/chat_appBar.dart';

import 'package:tito_app/src/data/models/debate_info.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tito_app/src/view/chatView/ended_chat_body.dart';

class EndedChat extends ConsumerStatefulWidget {
  final int id;

  const EndedChat({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<EndedChat> createState() => _EndedChatState();
}

class _EndedChatState extends ConsumerState<EndedChat> {
  @override
  void initState() {
    super.initState();
    _fetchDebateInfo();
  }

  Future<void> _fetchDebateInfo() async {
    final chatViewModel = ref.read(chatInfoProvider.notifier);

    await chatViewModel.fetchDebateInfo(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final debateInfo = ref.watch(chatInfoProvider);

    if (debateInfo == null) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: SpinKitThreeBounce(
            color: ColorSystem.grey3,
            size: 30.sp,
            duration: Duration(seconds: 2), //속도 설정
          ),
        ),
      );
    }

    return _BasicDebate(
      id: widget.id,
      debateInfo: debateInfo,
    );
  }
}

class _BasicDebate extends StatelessWidget {
  final int id;
  final DebateInfo? debateInfo;

  const _BasicDebate({
    required this.id,
    required this.debateInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: ChatAppbar(id: id), // id 전달
      ),
      body: EndedChatBody(id: id),
    );
  }
}

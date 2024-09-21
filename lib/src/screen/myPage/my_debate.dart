import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/view/myPage/my_debate_appbar.dart';
import 'package:tito_app/src/view/myPage/my_debate_firstbody.dart';
import 'package:tito_app/src/view/myPage/my_debate_scrollbody.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyDebate extends ConsumerStatefulWidget {
  const MyDebate({super.key});

  @override
  ConsumerState<MyDebate> createState() {
    return _MyDebateState();
  }
}

class _MyDebateState extends ConsumerState<MyDebate> {
  final List<String> sortOptions = ['최신순', '인기순'];

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.h),
          child: const MyDebateAppbar(),
        ),
        body: Column(
          children: [
            const MyDebateFirstbody(),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 8.0,
                radius: Radius.circular(20.r),
                child: const MyDebateScrollbody(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

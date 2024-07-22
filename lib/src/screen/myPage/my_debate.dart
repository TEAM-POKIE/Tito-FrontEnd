import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/view/myPage/my_debate_appbar.dart';
import 'package:tito_app/src/view/myPage/my_debate_firstbody.dart';
import 'package:tito_app/src/view/myPage/my_debate_scrollbody.dart';

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
    return const ProviderScope(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: MyDebateAppbar(),
        ),
        body: Column(
          children: [
            MyDebateFirstbody(),
            Expanded(
              child: MyDebateScrollbody(),
            ),
          ],
        ),
      ),
    );
  }
}

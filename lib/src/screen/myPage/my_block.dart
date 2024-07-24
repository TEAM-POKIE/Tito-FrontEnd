import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/view/myPage/my_block_appbar.dart';
import 'package:tito_app/src/view/myPage/my_block_scrollbody.dart';
import 'package:tito_app/src/view/myPage/my_like_appbar.dart';
import 'package:tito_app/src/view/myPage/my_like_scrollbody.dart';


class MyBlock extends ConsumerWidget {
  const MyBlock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ProviderScope(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: MyBlockAppbar(),
        ),
        body: MyBlockScrollbody(),
      ),
    );
  }
}
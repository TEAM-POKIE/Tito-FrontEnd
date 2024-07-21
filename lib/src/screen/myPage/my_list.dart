import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/view/myPage/my_list_appbar.dart';
import 'package:tito_app/src/view/myPage/my_list_scrollbody.dart';

class MyList extends ConsumerWidget {
  const MyList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ProviderScope(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: MyListAppbar(),
        ),
        body: MyListScrollbody(),
      ),
    );
  }
}

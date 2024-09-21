import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:tito_app/src/view/myPage/my_block_appbar.dart';
import 'package:tito_app/src/view/myPage/my_block_scrollbody.dart';

class MyBlock extends ConsumerWidget {
  const MyBlock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: MyBlockAppbar(),
        ),
        body: MyBlockScrollbody(),
      ),
    );
  }
}

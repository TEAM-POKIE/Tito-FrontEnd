import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:tito_app/core/provider/freewrite_provider.dart';

class FreeDetailList extends ConsumerStatefulWidget {
  @override
  _FreeDetailListState createState() => _FreeDetailListState();
}

class _FreeDetailListState extends ConsumerState<FreeDetailList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text('애인의 우정여행 어떻게 생각해?')],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/view/freeView/free_appbar.dart';
import 'package:tito_app/src/view/freeView/free_view.dart';

class FreeScreen extends ConsumerWidget {
  const FreeScreen({super.key});

  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: FreeAppbar(),
      ),
      body: Stack(children: [FreeView()]),
    );
  }
}

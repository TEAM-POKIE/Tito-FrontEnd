import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/view/freeView/free_write_appbar.dart';
import 'package:tito_app/src/view/freeView/free_write_body.dart';

class FreeWriteScreen extends ConsumerWidget {
  const FreeWriteScreen({super.key});

  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: FreeWriteAppbar(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FreeWriteBody(),
        ],
      ),
    );
  }
}
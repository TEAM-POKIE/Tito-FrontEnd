import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/view/freeView/free_detail_appbar.dart';
import 'package:tito_app/core/provider/freewrite_provider.dart';
import 'package:tito_app/src/view/freeView/free_detail_list.dart';

class FreeDetailScreen extends ConsumerWidget {
  const FreeDetailScreen({super.key});

  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      child: Scaffold(
        appBar:const PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: FreeDetailAppbar(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FreeDetailList(),
            ],
          )
        ),
      ),
    );
  }
}

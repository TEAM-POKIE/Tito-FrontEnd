import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/view/freeView/free_detail_appbar.dart';
import 'package:tito_app/core/provider/post_provider.dart';
import 'package:tito_app/src/view/freeView/free_detail_list.dart';

class FreeDetailScreen extends ConsumerWidget {
  final Post post;
  const FreeDetailScreen ({Key? key, required this.post}) : super(key: key);
  
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
              FreeDetailList(post: post),
            ],
          )
        ),
      ),
    );
  }
}

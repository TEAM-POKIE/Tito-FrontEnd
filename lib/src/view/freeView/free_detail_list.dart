import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:tito_app/core/provider/post_provider.dart';
import 'package:tito_app/core/provider/post_provider.dart';

class FreeDetailList extends ConsumerWidget {
  final Post post;
  const FreeDetailList({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postProvider);

    return Column(
      children: [
        Text(post.title)]);
  }
}

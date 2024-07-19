import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FreeDetailAppbar extends ConsumerWidget {
  const FreeDetailAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          context.go('/free');
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
    );
  }
}
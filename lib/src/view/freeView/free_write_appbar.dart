import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/data/models/freescreen_info.dart';

class FreeWriteAppbar extends ConsumerWidget {
  const FreeWriteAppbar({super.key});

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

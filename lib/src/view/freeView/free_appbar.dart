import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// final homeViewModelProvider = StateNotifierProvider<HomeViewmodel, HomeState>(
//   (ref) => HomeViewmodel(),
// );

class FreeAppbar extends ConsumerWidget {
  const FreeAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
        title: const Text(
          '자유게시판',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
  }
}


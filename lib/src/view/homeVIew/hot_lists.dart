import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tito_app/src/viewModel/homeViewModel/home_viewModel.dart';

final homeViewModelProvider = StateNotifierProvider<HomeViewmodel, HomeState>(
  (ref) => HomeViewmodel(),
);

class HotLists extends ConsumerWidget {
  const HotLists({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final homeViewModel = ref.read(homeViewModelProvider.notifier);
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'HOT한 토론',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        homeViewModel.goListPage(context);
                      },
                      child: const Text('더보기 >'))
                ],
              ),
            ),
            Column(
              children: List.generate(homeState.hotItems.length, (index) {
                final hotItem = homeState.hotItems[index];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/images/hotlist.png', // Add your image path here
                        width: 40,
                        height: 40,
                      ),
                      title: Text(
                        hotItem.hotTitle[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(hotItem.hotContent[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.whatshot,
                            color: Colors.purple,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            hotItem.hotScore.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

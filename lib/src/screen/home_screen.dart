import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/view/homeVIew/home_appbar.dart';
import 'package:tito_app/src/view/homeVIew/home_view.dart';
import 'package:tito_app/src/view/homeVIew/hot_lists.dart';
import 'package:tito_app/src/viewModel/homeViewModel/home_viewModel.dart';
import 'package:tito_app/src/widgets/reuse/search_bar.dart';

final homeViewModelProvider = StateNotifierProvider<HomeViewmodel, HomeState>(
  (ref) => HomeViewmodel(),
);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: HomeAppbar(),
      ), // AppBar를 위젯으로 사용
      body: homeState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                CustomSearchBar(),

                const HomeView(), // HomeView를 Expanded로 감싸서 남은 공간을 모두 차지하게 함
                const HotLists() // HotList도 추가
              ],
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/view/homeVIew/home_appbar.dart';
import 'package:tito_app/src/view/homeVIew/home_view.dart';
import 'package:tito_app/src/view/homeVIew/hot_lists.dart';

import 'package:tito_app/src/widgets/reuse/search_bar.dart';
import 'package:tito_app/core/provider/home_state_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: HomeAppbar(),
      ),
      body: homeState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : const Column(
              children: [CustomSearchBar(), HomeView(), HotLists()],
            ),
    );
  }
}

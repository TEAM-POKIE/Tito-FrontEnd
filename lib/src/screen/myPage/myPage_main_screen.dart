import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/view/myPage/myPage_appbar.dart';
import 'package:tito_app/src/view/myPage/myPage_main.dart';
import 'package:tito_app/src/widgets/reuse/bottombar.dart';

class MypageMainScreen extends ConsumerWidget {
  const MypageMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: MypageAppbar(),
      ),
      body: SingleChildScrollView(
        child: MypageMain(),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}

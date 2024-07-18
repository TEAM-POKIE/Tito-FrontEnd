import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/view/myPage/logout_popup.dart';
import 'package:tito_app/src/widgets/reuse/debate_popup.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:tito_app/src/viewModel/popup_viewModel.dart';
import 'package:tito_app/core/provider/chat_state_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:tito_app/core/provider/turn_provider.dart';
import 'package:tito_app/src/viewModel/popup_viewModel.dart';
import 'package:tito_app/src/view/myPage/exit_popup.dart';

class MypageMain extends ConsumerWidget {
  const MypageMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginInfo = ref.watch(loginInfoProvider);
    return Column(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage(
                  'assets/images/chatprofile.png'), //replace with your image asset
            ),
            Positioned(
              bottom: -15,
              right: -15,
              child: IconButton(
                iconSize: 30.0,
                onPressed: () {
                  //context.go('/nickname');
                },
                icon: Image.asset('assets/images/changeprofile.png'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 35.0),
              child: Text(
                '${loginInfo?.nickname}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              onPressed: () {
                context.go('/nickname');
              },
              icon: const Icon(Icons.arrow_forward_ios),
              iconSize: 18.0,
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 221, 199, 255),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            '승률 80%',
            style: TextStyle(
                color: Color(0xFF8E48F8), fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          '12전 | 10승 | 2패',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 20),
        const Divider(
          thickness: 2,
        ),
        const SizedBox(
          height: 15.0,
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '내 활동',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              title: const Text('내가 참여한 토론'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.go('/mydebate');
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              title: const Text('내가 쓴 게시글'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.go('/mylist');
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              title: const Text('좋아요'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.go('/mylike');
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              title: const Text('알림'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.go('/myalarm');
              },
            ),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        const Divider(
          thickness: 2,
        ),
        const SizedBox(height: 15.0),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '설정',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              title: const Text('비밀번호 수정'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.go('/password');
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              title: const Text('문의하기'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.go('/contact');
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              title: const Text('로그아웃'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                showLogoutDialog(context);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              title: const Text('회원탈퇴'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                showExitDialog(context);
              },
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_state_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:tito_app/src/viewModel/chat_viewModel.dart';

class ChatAppbar extends ConsumerWidget {
  const ChatAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProviders);
    final loginInfo = ref.read(loginInfoProvider);

    return DebateAppbar(
      title: 'title',
      notiIcon: 'assets/images/debateAlarm.png',
    );
  }
}

class DebateAppbar extends ConsumerWidget {
  final ChatViewModel? chatViewModel;
  final String title;
  final String? notiIcon;

  const DebateAppbar({
    super.key,
    this.chatViewModel,
    required this.title,
    this.notiIcon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popupViewModel = ref.read(popupProvider.notifier);
    final popupState = ref.read(popupProvider);

    final List<String> menuItems = [
      '토론 삭제하기',
      '토론룰 보기',
    ];

    return AppBar(
      backgroundColor: ColorSystem.white,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () {
          context.pop(context);
        },
      ),
      actions: [
        if (notiIcon != null && notiIcon!.isNotEmpty)
          IconButton(
            icon: Image.asset(notiIcon!),
            onPressed: () {
              popupState.title = '토론 시작 시 알림을 보내드릴게요!';
              popupState.imgSrc = 'assets/images/debatePopUpAlarm.png';
              popupState.content =
                  '토론 참여자가 정해지고 \n최종 토론이 개설 되면 \n푸시알림을 통해 알려드려요';
              popupState.buttonContentLeft = '네 알겠어요';
              popupState.buttonStyle = 1;
              popupViewModel.showDebatePopup(context);
            },
          ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: DropdownButton2<String>(
            customButton: const Icon(Icons.more_vert, color: Colors.black),
            items: menuItems.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center, // Align text to the left
                      child: Text(item, style: FontSystem.KR16B),
                    ),
                    if (item != menuItems.last)
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                        indent: 10,
                        endIndent: 10,
                      ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == '토론 삭제하기') {
                // 토론 삭제 로직 추가
              } else if (value == '토론룰 보기') {
                popupViewModel.showRulePopup(context);
              }
            },
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 48,
              width: 48, // Adjust this width
            ),
            dropdownStyleData: const DropdownStyleData(
              padding: EdgeInsets.all(10),
              maxHeight: 150,
              width: 140, // Adjust this width for dropdown
              offset: Offset(0, -5), // Adjust the offset if needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }
}

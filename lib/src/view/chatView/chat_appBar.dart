import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/nav_provider.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatAppbar extends ConsumerWidget {
  final int id;

  const ChatAppbar({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debateState = ref.read(chatInfoProvider);
    switch (debateState!.debateJoinerTurnCount) {
      case 0:
        return DebateAppbar(
          title: debateState.debateTitle,
          notiIcon: 'assets/images/debateAlarm.png',
        );
      default:
        return DebateAppbar(
          title: debateState.debateTitle,
        );
    }
  }
}

class DebateAppbar extends ConsumerWidget {
  final String title;
  final String? notiIcon;

  const DebateAppbar({
    super.key,
    required this.title,
    this.notiIcon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popupViewModel = ref.read(popupProvider.notifier);
    final chatViewModel = ref.read(chatInfoProvider.notifier);
    final debateState = ref.read(chatInfoProvider);
    final loginInfo = ref.read(loginInfoProvider);
    final bottomState = ref.read(selectedIndexProvider.notifier);

    final List<String> menuItems =
        debateState!.debateOwnerId == loginInfo!.id &&
                debateState.debateJoinerTurnCount == 0
            ? ['토론 삭제하기', '토론룰 보기']
            : ['토론룰 보기', '신고하기'];

    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: ColorSystem.white,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 150.0.w,
            ),
            child: Text(
              title,
              style: FontSystem.KR16SB,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: () {
              popupViewModel.showTitlePopup(context);
            },
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 30.sp,
          ),
        ],
      ),
      centerTitle: true,
      leading: IconButton(
        icon: SvgPicture.asset('assets/icons/back_arrow.svg'),
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            bottomState.state = 0;
            context.go('/home');
          }
        },
      ),
      actions: [
        if (notiIcon != null && notiIcon!.isNotEmpty)
          IconButton(
            icon: SvgPicture.asset('assets/icons/chat_appbar_bell.svg'),
            onPressed: () {
              chatViewModel.alarmButton(context);
            },
          ),
        Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: DropdownButton2<String>(
            customButton: const Icon(Icons.more_vert, color: ColorSystem.black),
            items: menuItems.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center, // Align text to the left
                      child: Text(item, style: FontSystem.KR14B),
                    ),
                    if (item != menuItems.last)
                      const Divider(
                        thickness: 1,
                        color: ColorSystem.grey,
                        indent: 10,
                        endIndent: 10,
                      ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == '토론 삭제하기') {
                popupViewModel.showDeletePopup(context);
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
              width: 240, // Adjust this width for dropdown
              offset: Offset(0, -5), // Adjust the offset if needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: ColorSystem.white,
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:tito_app/core/provider/home_state_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HotFighter extends ConsumerStatefulWidget {
  const HotFighter({super.key});

  @override
  ConsumerState<HotFighter> createState() => _HotFighterState();
}

class _HotFighterState extends ConsumerState<HotFighter> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeViewModel = ref.read(homeViewModelProvider.notifier);
      homeViewModel.fetchHotfighter();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);
    final chatviewModel = ref.watch(chatInfoProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'HOT한 토론러',
              style: FontSystem.KR18SB,
            ),
            SizedBox(
              width: 4.w,
            ),
            Container(
                width: 20.w,
                height: 20.h,
                child: SvgPicture.asset('assets/icons/star.svg')),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        Container(
          height: 110.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: homeState.hotfighter.length,
            itemBuilder: (context, index) {
              final fighter = homeState.hotfighter[index];

              return Container(
                margin: index == 0
                    ? EdgeInsets.only(right: 10.w)
                    : EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        chatviewModel.getProfile(fighter.userId, context);
                      },
                      child: CircleAvatar(
                        radius: 30.w,
                        backgroundImage: fighter.profilePicture != null
                            ? NetworkImage(fighter.profilePicture!)
                            : null,
                        child: fighter.profilePicture == null
                            ? SvgPicture.asset(
                                'assets/icons/basicProfile.svg',
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      width: 60.w,
                      child: Text(
                        fighter.nickname,
                        style: FontSystem.KR16M,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

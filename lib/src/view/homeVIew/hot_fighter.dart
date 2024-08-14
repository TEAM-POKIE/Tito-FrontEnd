import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
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
        ),
        SizedBox(
          height: 20.h,
        ),
        Container(
          padding: EdgeInsets.only(left: 10.w),
          height: 110.h, // 컨테이너 높이를 더 키워서 아바타와 텍스트가 잘리지 않도록 합니다.
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: homeState.hotfighter.length, // API에서 가져온 데이터 길이
            itemBuilder: (context, index) {
              final fighter = homeState.hotfighter[index]; // 해당 index의 데이터를 가져옴

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 35.w, 
                      // 아바타의 크기를 키움
                      backgroundColor: ColorSystem.purple,
                      backgroundImage: fighter.profilePicture != null
                          ? NetworkImage(fighter.profilePicture!)
                          : AssetImage('assets/images/hot_fighter.png')
                              as ImageProvider, // 프로필 이미지 경로
                    ),
                    SizedBox(height: 10.h), // 간격을 조금 더 넓힘
                    Container(
                      width: 60.w, // 텍스트가 한 줄로 보이게끔 컨테이너 폭을 조정
                      child: Text(
                        fighter.nickname,
                        style: FontSystem.KR16M,
                        maxLines: 1, // 텍스트를 한 줄로 제한
                        overflow: TextOverflow.ellipsis, // 넘칠 경우 "..." 처리
                        textAlign: TextAlign.center, // 텍스트를 가운데 정렬
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

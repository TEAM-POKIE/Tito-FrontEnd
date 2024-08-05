import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tito_app/core/provider/home_state_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';

class HotLists extends ConsumerWidget {
  const HotLists({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final homeViewModel = ref.read(homeViewModelProvider.notifier);
    return Expanded(
      child: Column(
        children: [
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.h,
            ),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'HOT한 토론',
                  style: FontSystem.KR18B,
                ),
                SizedBox(
                  width: 6.w,
                ),
                Container(
                    width: 39.5.w,
                    height: 29.06.h,
                    child: Image.asset('assets/images/hotlist.png')),
                // TextButton(
                //     onPressed: () {
                //       homeViewModel.goListPage(context);
                //     },
                //     child: const Text('더보기 >'))
              ],
            ),
          ),
          Column(
            children: List.generate(homeState.hotItems.length, (index) {
              final hotItem = homeState.hotItems[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorSystem.white,
                    borderRadius: BorderRadius.circular(20.r),
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
                      maxLines: 1, // 텍스트를 한 줄로 제한
                      overflow: TextOverflow.ellipsis, // 넘칠 경우 "..." 처리
                    ),
                    subtitle: Text(
                      hotItem.hotContent[index],
                      maxLines: 1, // 텍스트를 한 줄로 제한
                      overflow: TextOverflow.ellipsis, // 넘칠 경우 "..." 처리
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.whatshot,
                          color: ColorSystem.purple,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          hotItem.hotScore.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: ColorSystem.grey,
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
    );
  }
}

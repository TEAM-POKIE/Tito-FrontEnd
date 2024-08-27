import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/home_state_provider.dart';
import 'package:flutter_svg/svg.dart';

class HotLists extends ConsumerStatefulWidget {
  const HotLists({super.key});

  @override
  ConsumerState<HotLists> createState() {
    return _HotListState();
  }
}

class _HotListState extends ConsumerState<HotLists> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeViewModel = ref.read(homeViewModelProvider.notifier);
      homeViewModel.fetchHotDebates();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);

    return Column(
      children: [
        SizedBox(height: 30.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.h),
          child: Row(
            children: [
              Text(
                'HOT한 토론',
                style: FontSystem.KR18SB,
              ),
              SizedBox(width: 6.w),
              Container(
                width: 39.5.w,
                height: 29.06.h,
                child: Image.asset('assets/images/hotlist.png'),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          height: 300.h,
          child: homeState.isLoading
              ? Center(child: CircularProgressIndicator())
              : homeState.hotlist.isEmpty
                  ? Center(child: Text('No debates available'))
                  : ListView.builder(
                      itemCount: homeState.hotlist.length,
                      itemBuilder: (context, index) {
                        final debate = homeState.hotlist[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.h, horizontal: 10.w),
                          child: Container(
                            width: 350.w,
                            height: 100.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x669795A3),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                )
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.h, horizontal: 5.w),
                              child: ListTile(
                                trailing: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.r),
                                  child: (debate.debateImageUrl != null &&
                                          debate.debateImageUrl!.isNotEmpty)
                                      ? Image.network(
                                          debate.debateImageUrl!,
                                          width: 100.w,
                                          height: 100.h,
                                          fit: BoxFit.cover,
                                        )
                                      : SvgPicture.asset(
                                          'assets/icons/list_real_null.svg',
                                          width: 100.w,
                                          height: 100.h,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                title: Text(
                                  debate.debateTitle,
                                  style: FontSystem.KR18SB,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5.h),
                                    Text(
                                        '${debate.debateMakerOpinion} VS ${debate.debateJoinerOpinion}',
                                        style: FontSystem.KR16M,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    SizedBox(height: 5.h),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/icons/fire.svg'),
                                        SizedBox(width: 4.w),
                                        Text(
                                          '${debate.debateFireCount}',
                                          style: FontSystem.KR16M.copyWith(
                                              color: ColorSystem.grey),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5.h),
                                    // 추가: DebateHotdebate의 toString 결과를 표시
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/home_state_provider.dart';

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
          padding: EdgeInsets.symmetric(
            horizontal: 20.h,
          ),
          child: Row(
            children: [
              const Text(
                'HOT한 토론',
                style: FontSystem.KR18SB,
              ),
              SizedBox(
                width: 6.w,
              ),
              Container(
                  width: 39.5.w,
                  height: 29.06.h,
                  child: Image.asset('assets/images/hotlist.png')),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          height: 400.h, // 리스트 높이를 충분히 키움
          child: homeState.isLoading
              ? Center(child: CircularProgressIndicator()) // 로딩 중일 때
              : homeState.hotlist.isEmpty
                  ? Center(child: Text('No debates available')) // 데이터가 없을 때
                  : ListView.builder(
                      itemCount: homeState.hotlist.length,
                      itemBuilder: (context, index) {
                        final debate = homeState.hotlist[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(15.w),
                              trailing: ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Image.network(
                                  debate.debateImageUrl ??
                                      'https://via.placeholder.com/150',
                                  width: 100.w,
                                  height: 100.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                debate.debateTitle,
                                style: FontSystem.KR16B,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8.h),
                                  Text(
                                    '${debate.debateMakerOpinion} VS ${debate.debateJoinerOpinion}',
                                    style: FontSystem.KR14R.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      Icon(Icons.whatshot,
                                          color: Colors.purple, size: 20.w),
                                      SizedBox(width: 4.w),
                                      Text(
                                        '${debate.debateFireCount}',
                                        style: FontSystem.KR14M
                                            .copyWith(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
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

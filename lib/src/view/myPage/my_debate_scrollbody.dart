import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/screen/home_screen.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyDebateScrollbody extends ConsumerStatefulWidget {
  const MyDebateScrollbody({super.key});

  @override
  _MyDebateScrollbodyState createState() => _MyDebateScrollbodyState();
}

class _MyDebateScrollbodyState extends ConsumerState<MyDebateScrollbody> {
  final GlobalKey<AnimatedListState> _debateListKey =
      GlobalKey<AnimatedListState>();
  final List<int> _items = List<int>.generate(5, (int index) => index);

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _debateListKey,
      initialItemCount: _items.length,
      itemBuilder: (context, index, animation) {
        return _buildItem(context, index, animation);
      },
    );
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(-1, 0),
        end: Offset(0, 0),
      ).animate(animation),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        child: Row(
          children: [
            Container(
              width: 350.w,
              height: 130.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: ColorSystem.grey),
              ),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 0.w),
                      child: Text(
                        '2024.6.20',
                        style: TextStyle(fontSize: 14.sp, color: ColorSystem.grey),
                      ),
                    ),
                    Divider(color: ColorSystem.grey),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 0.w),
                          child:
                              const Text('아싸 애인 VS 인싸 애인', style: FontSystem.KR15B),
                        ),
                        SizedBox(height: 5.h),
                        Padding(
                          padding: EdgeInsets.only(left: 0.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '의견: 아싸 애인이 더 좋다',
                                style: FontSystem.KR14R
                                    .copyWith(color: ColorSystem.grey),
                              ),
                             // SizedBox(height: 4.h),
                              Padding(
                                padding: EdgeInsets.only(left: 0.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '결과: 승',
                                      style: FontSystem.KR14R
                                          .copyWith(color: ColorSystem.purple),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ), //여기 !!
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

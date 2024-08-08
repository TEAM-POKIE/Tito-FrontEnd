import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/src/widgets/reuse/block_popup.dart';
import 'package:tito_app/core/provider/login_provider.dart';

class ProfilePopup extends ConsumerStatefulWidget {
  const ProfilePopup({super.key});

  @override
  ConsumerState<ProfilePopup> createState() {
    return _ProfilePopupState();
  }
}

class _ProfilePopupState extends ConsumerState<ProfilePopup> {
  List<String> items = List<String>.generate(4, (index) => "아싸 애인 VS 인싸 애인");
  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          _removeOverlay();
        },
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                top: 235.h,
                left: 220.w,
                child: InkResponse(
                  onTap: () {
                    _removeOverlay();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BlockPopup();
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorSystem.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x669795A3),
                          spreadRadius: 0,
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                      child: const Text(
                        '사용자 차단',
                        style: FontSystem.KR14SB,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context)!.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // 외부 이벤트에 의해 호출될 수 있는 메서드
  void addNewDiscussion(String newDiscussion) {
    setState(() {
      items.add(newDiscussion);
    });
  }

  @override
  Widget build(BuildContext context) {
    // // 실제로는 아래 부분이 사용자가 토론에 참여되면 호출되어 토론이 추가되야 함
    // Future.delayed(Duration(seconds: 3), () {
    //   addNewDiscussion("새로운 토론 항목 ${items.length + 1}");
    // });

    return Dialog(
      backgroundColor: ColorSystem.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        width: 350.w,
        height: 580.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 19.h),
            Row(
              children: [
                SizedBox(width: 140.w),
                const Text('프로필', style: FontSystem.KR14B),
                SizedBox(width: 80.w),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            _buildProfileHeader(ref),
            const Divider(
              color: ColorSystem.grey3,
              thickness: 2,
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const Text(
                '참여한 토론',
                style: FontSystem.KR14B,
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return _buildListItem(context, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(WidgetRef ref) {
    final loginInfo = ref.watch(loginInfoProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 25.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/icons/circle_profile.svg'), // 본인의 이미지 자산으로 대체
                radius: 35.r,
              ),
              SizedBox(width: 15.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Row(
                        children: [
                          Text('${loginInfo?.nickname}',
                              style: FontSystem.KR24B),
                          SizedBox(width: 5.w),
                          Container(
                            decoration: BoxDecoration(
                                color: ColorSystem.lightPurple,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: ColorSystem.purple,
                                )),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6.h, vertical: 6.h),
                              child: Text('승률 80%',
                                  textAlign: TextAlign.center,
                                  style: FontSystem.KR14B
                                      .copyWith(color: ColorSystem.purple)),
                            ),
                          ),
                          //SizedBox(width: 24.w),
                          Stack(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (_overlayEntry == null) {
                                    _showOverlay(context);
                                  } else {
                                    _removeOverlay();
                                  }
                                },
                                icon: Icon(Icons.more_vert),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text('12전 | 10승 | 2패', style: FontSystem.KR18R),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: const [
            BoxShadow(
              color: Color(0x669795A3),
              spreadRadius: 0,
              blurRadius: 4,
            )
          ],
        ),
        child: ListTile(
          title: Text(
            items[index],
            style: FontSystem.KR15B,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '의견: 아싸 애인이 더 좋다',
                style: FontSystem.KR14R.copyWith(color: ColorSystem.grey),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                '결과: 승',
                style: FontSystem.KR14R.copyWith(color: ColorSystem.purple),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

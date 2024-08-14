import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/userProfile_provider.dart';
import 'package:tito_app/src/widgets/reuse/block_popup.dart';
import 'package:tito_app/core/provider/login_provider.dart';

class Debateinfopopup extends ConsumerStatefulWidget {
  const Debateinfopopup({super.key});

  @override
  ConsumerState<Debateinfopopup> createState() {
    return _DebateinfoState();
  }
}

class _DebateinfoState extends ConsumerState<Debateinfopopup> {
  List<String> items = List<String>.generate(4, (index) => "아싸 애인 VS 인싸 애인");
  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final popupViewModel = ref.read(popupProvider.notifier);
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
                    popupViewModel.showBlockPopup(context);
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
                      child: Text(
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
    final chatState = ref.read(chatInfoProvider);
    final loginInfo = ref.read(loginInfoProvider);
    return Dialog(
      backgroundColor: ColorSystem.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        width: 350.w,
        height: 420.h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(chatState!.debateTitle, style: FontSystem.KR18SB),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: const Divider(
                color: ColorSystem.grey3,
                thickness: 2,
              ),
            ),
            _buildProfileHeader(ref),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              // child: chatState.debateImageUrl == ''
              //                       ? SvgPicture.asset(
              //                           'assets/icons/list_real_null.svg',
              //                           fit: BoxFit.contain,
              //                         )
              //                       : ClipRRect(
              //                           borderRadius: BorderRadius.circular(
              //                               12.r), // 둥근 모서리 설정
              //                           child: Image.network(
              //                             chatState.debateImageUrl ?? '',
              //                             width: 260.w, // 원하는 너비 설정
              //                             height: 250.h,
              //                             fit: BoxFit
              //                                 .cover, // 이미지가 잘리지 않도록 맞춤 설정
              //                           ),
              //                         ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(WidgetRef ref) {
    final loginInfo = ref.watch(loginInfoProvider);
    final userState = ref.read(userProfileProvider);

    final chatState = ref.read(chatInfoProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
          child: Row(
            children: [
              SvgPicture.asset('assets/icons/popup_face.svg'),
              SizedBox(width: 10),
              Expanded(
                child: Text('몇 세기동안 이어온 논제! 외계인은 있는가? 없는가? 오늘 담판을 보자!',
                    style: FontSystem.KR14SB),
              ),
            ],
          ),
          // Row(
        ),
      ],
    );
  }
}

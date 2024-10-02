import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart'; //text painter 사용하려고 import 함

class Debateinfopopup extends ConsumerStatefulWidget {
  const Debateinfopopup({super.key});

  @override
  ConsumerState<Debateinfopopup> createState() {
    return _DebateinfoState();
  }
}

class _DebateinfoState extends ConsumerState<Debateinfopopup> {
  @override
  Widget build(BuildContext context) {
    final chatState = ref.read(chatInfoProvider);
    // final String text=chatState!.debateTitle;

    // bool isTextOverflowing(String text, TextStyle style, double maxWidth) {
    //   final textPainter = TextPainter(
    //     //Flutter에서 텍스트를 그리기 전에 레이아웃을 계산하는 도구
    //     text: TextSpan(text: text, style: style),
    //     maxLines: 1,
    //     textDirection: TextDirection.ltr,
    //   );
    //   textPainter.layout(maxWidth: maxWidth);
    //   return textPainter.didExceedMaxLines;
    // }
    // // 화면의 가로 길이를 가져옴
    // final screenWidth = MediaQuery.of(context).size.width;
    // // 텍스트가 한 줄을 넘기는지 확인
    // final isOverflowing = isTextOverflowing(
    //   text,
    //   FontSystem.KR16SB, // KR16SB 스타일
    //   screenWidth,
    // );

    return Dialog(
      backgroundColor: ColorSystem.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 20.h, bottom: 0.h, right: 25.w, left: 25.w),
                          child: Text(chatState!.debateTitle,
                              style: FontSystem.KR16SB,
                              //overflow: TextOverflow.ellipsis,
                              //maxLines: 2,
                              textAlign: TextAlign.start,
                              softWrap: true, //자연스러운 줄바꿈
                              overflow: TextOverflow.visible),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: -12.h,
                    right: -10.w,
                    child: IconButton(
                      iconSize: 20,
                      icon: const Icon(Icons.close, color: ColorSystem.grey),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: const Divider(
                color: ColorSystem.grey3,
                thickness: 1,
              ),
            ),
            _buildProfileHeader(ref),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Center(
                child: chatState.debateImageUrl == ''
                    ? SizedBox(width: 0.w) // 이미지 없을 때 회색 이미지도 없애기
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.network(
                          chatState.debateImageUrl,
                          height: 250.h,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(WidgetRef ref) {
    final chatState = ref.read(chatInfoProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset('assets/icons/popup_face.svg'),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(chatState!.debateContent, style: FontSystem.KR14SB),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

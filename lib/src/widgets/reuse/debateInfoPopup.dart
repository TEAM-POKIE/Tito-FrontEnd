import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/src/data/models/login_info.dart'; //text painter 사용하려고 import 함

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
    final loginInfo = ref.read(loginInfoProvider);
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
            chatState.debateJoinerTurnCount == 0
                ? SizedBox(
                    width: 0,
                  )
                : Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 14.h,
                        horizontal: 22.w,
                      ),
                      decoration: BoxDecoration(
                        color: ColorSystem.ligthGrey,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: loginInfo!.nickname == chatState.debateJoinerNick
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 64, // 필요에 따라 크기 조정
                                      height: 64, // 필요에 따라 크기 조정
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: ColorSystem
                                              .voteBlue, // 파란색 테두리 색상
                                          width: 4.0, // 테두리 두께
                                        ),
                                      ),
                                      child: chatState.debateOwnerPicture !=
                                                  null &&
                                              chatState
                                                  .debateOwnerPicture.isNotEmpty
                                          ? CircleAvatar(
                                              backgroundColor: Colors
                                                  .transparent, // 배경 투명하게 설정
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                chatState.debateOwnerPicture,
                                              ),
                                            )
                                          : SvgPicture.asset(
                                              'assets/icons/basicProfile.svg',
                                              width: 60, // 아이콘 크기 조정
                                              height: 60,
                                            ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Text(
                                      chatState.debateOwnerNick,
                                      style: FontSystem.KR14SB,
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Text(
                                      chatState.debateMakerOpinion,
                                      style: FontSystem.KR14M,
                                    ),
                                  ],
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(maxWidth: 250),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  decoration: BoxDecoration(
                                    color: ColorSystem.black,
                                    borderRadius: BorderRadius.circular(17.0.r),
                                  ),
                                  child: Text(
                                    'VS',
                                    style: FontSystem.KR12M
                                        .copyWith(color: ColorSystem.white),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: 64, // 필요에 따라 크기 조정
                                      height: 64, // 필요에 따라 크기 조정
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color:
                                              ColorSystem.voteRed, // 파란색 테두리 색상
                                          width: 4.0, // 테두리 두께
                                        ),
                                      ),
                                      child: chatState.debateJoinerPicture !=
                                                  null &&
                                              chatState.debateJoinerPicture
                                                  .isNotEmpty
                                          ? CircleAvatar(
                                              backgroundColor: Colors
                                                  .transparent, // 배경 투명하게 설정
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                chatState.debateJoinerPicture,
                                              ),
                                            )
                                          : SvgPicture.asset(
                                              'assets/icons/basicProfile.svg',
                                              width: 60, // 아이콘 크기 조정
                                              height: 60,
                                            ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Text(
                                      chatState.debateJoinerNick,
                                      style: FontSystem.KR14SB,
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Text(
                                      chatState.debateJoinerOpinion,
                                      style: FontSystem.KR14M,
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 64, // 필요에 따라 크기 조정
                                      height: 64, // 필요에 따라 크기 조정
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: ColorSystem
                                              .voteBlue, // 파란색 테두리 색상
                                          width: 4.0, // 테두리 두께
                                        ),
                                      ),
                                      child: chatState.debateJoinerPicture !=
                                                  null &&
                                              chatState.debateJoinerPicture
                                                  .isNotEmpty
                                          ? CircleAvatar(
                                              backgroundColor: Colors
                                                  .transparent, // 배경 투명하게 설정
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                chatState.debateJoinerPicture,
                                              ),
                                            )
                                          : SvgPicture.asset(
                                              'assets/icons/basicProfile.svg',
                                              width: 60, // 아이콘 크기 조정
                                              height: 60,
                                            ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Text(
                                      chatState.debateJoinerNick,
                                      style: FontSystem.KR14SB,
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Text(
                                      chatState.debateJoinerOpinion,
                                      style: FontSystem.KR14M,
                                    ),
                                  ],
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(maxWidth: 250),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  decoration: BoxDecoration(
                                    color: ColorSystem.black,
                                    borderRadius: BorderRadius.circular(17.0.r),
                                  ),
                                  child: Text(
                                    'VS',
                                    style: FontSystem.KR12M
                                        .copyWith(color: ColorSystem.white),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: 64, // 필요에 따라 크기 조정
                                      height: 64, // 필요에 따라 크기 조정
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color:
                                              ColorSystem.voteRed, // 파란색 테두리 색상
                                          width: 4.0, // 테두리 두께
                                        ),
                                      ),
                                      child: chatState.debateOwnerPicture !=
                                                  null &&
                                              chatState
                                                  .debateOwnerPicture.isNotEmpty
                                          ? CircleAvatar(
                                              backgroundColor: Colors
                                                  .transparent, // 배경 투명하게 설정
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                chatState.debateOwnerPicture,
                                              ),
                                            )
                                          : SvgPicture.asset(
                                              'assets/icons/basicProfile.svg',
                                              width: 60, // 아이콘 크기 조정
                                              height: 60,
                                            ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Text(
                                      chatState.debateOwnerNick,
                                      style: FontSystem.KR14SB,
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Text(
                                      chatState.debateMakerOpinion,
                                      style: FontSystem.KR14M,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ),
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

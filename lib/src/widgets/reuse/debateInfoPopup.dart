import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:tito_app/core/provider/ended_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/src/data/models/debate_info.dart';
import 'package:tito_app/src/data/models/login_info.dart';
import 'package:tito_app/src/viewModel/chat_viewModel.dart';

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

    return Dialog(
      backgroundColor: ColorSystem.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8, // 팝업의 최대 높이를 제한
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  child: Stack(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 20.h,
                                  bottom: 0.h,
                                  right: 25.w,
                                  left: 15.w),
                              child: Text(
                                chatState!.debateTitle,
                                style: FontSystem.KR16SB,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: -12.h,
                        right: -10.w,
                        child: IconButton(
                          iconSize: 20,
                          icon:
                              const Icon(Icons.close, color: ColorSystem.grey),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: ColorSystem.grey3,
                  thickness: 1,
                ),
                _buildProfileHeader(ref),
                chatState.debateStatus == "ENDED"
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 10.h),
                        child:
                            _buildEndedDebateInfo(ref, loginInfo!, chatState),
                      )
                    : const SizedBox(width: 0),
                chatState.debateJoinerTurnCount != 0 &&
                        chatState.debateStatus != "ENDED"
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 10.h),
                        child: _buildDebateInfo(ref, loginInfo!, chatState),
                      )
                    : const SizedBox(width: 0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Center(
                    child: chatState.debateImageUrl == ''
                        ? SizedBox(width: 0.w)
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
        ),
      ),
    );
  }

  Widget _buildDebateInfo(
      WidgetRef ref, LoginInfo loginInfo, DebateInfo chatState) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 22.w),
      decoration: BoxDecoration(
        color: ColorSystem.ligthGrey,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildProfileRow(chatState, false),
          Container(
            constraints: const BoxConstraints(maxWidth: 250),
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: ColorSystem.black,
              borderRadius: BorderRadius.circular(17.0.r),
            ),
            child: Text(
              'VS',
              style: FontSystem.KR12M.copyWith(color: ColorSystem.white),
            ),
          ),
          _buildProfileRow(chatState, true),
        ],
      ),
    );
  }

  Widget _buildEndedDebateInfo(
      WidgetRef ref, LoginInfo loginInfo, DebateInfo chatState) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 22.w),
      decoration: BoxDecoration(
        color: ColorSystem.ligthGrey,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildEndedProfileRow(chatState, false),
          Container(
            constraints: const BoxConstraints(maxWidth: 250),
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: ColorSystem.black,
              borderRadius: BorderRadius.circular(17.0.r),
            ),
            child: Text(
              'VS',
              style: FontSystem.KR12M.copyWith(color: ColorSystem.white),
            ),
          ),
          _buildEndedProfileRow(chatState, true),
        ],
      ),
    );
  }

  Widget _buildProfileRow(DebateInfo chatState, bool isOwner) {
    final loginInfo = ref.read(loginInfoProvider);
    return isOwner
        ? Row(
            children: [
              Column(
                children: [
                  _buildProfileImage(
                      chatState.debateJoinerNick == loginInfo!.nickname
                          ? chatState.debateOwnerPicture
                          : chatState.debateJoinerPicture,
                      ColorSystem.voteBlue),
                  SizedBox(height: 1.h),
                  Text(
                    chatState.debateJoinerNick == loginInfo.nickname
                        ? chatState.debateOwnerNick
                        : chatState.debateJoinerNick,
                    style: FontSystem.KR14SB,
                  ),
                ],
              ),
              SizedBox(
                width: 8.w,
              ),
              Container(
                width: 140.w,
                child: Text(
                  chatState.debateJoinerNick == loginInfo.nickname
                      ? chatState.debateMakerOpinion
                      : chatState.debateJoinerOpinion,
                  style: FontSystem.KR14M,
                  maxLines: null,
                  softWrap: true,
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  chatState.debateJoinerNick == loginInfo!.nickname
                      ? chatState.debateJoinerOpinion
                      : chatState.debateMakerOpinion,
                  style: FontSystem.KR14M,
                  textAlign: TextAlign.end,
                  maxLines: null,
                  softWrap: true,
                ),
              ),
              SizedBox(
                width: 8.w,
              ),
              Column(
                children: [
                  _buildProfileImage(
                      chatState.debateJoinerNick == loginInfo!.nickname
                          ? chatState.debateJoinerPicture
                          : chatState.debateOwnerPicture,
                      ColorSystem.voteRed),
                  SizedBox(height: 1.h),
                  Text(
                    chatState.debateJoinerNick == loginInfo.nickname
                        ? chatState.debateJoinerNick
                        : chatState.debateOwnerNick,
                    style: FontSystem.KR14SB,
                  ),
                ],
              ),
            ],
          );
  }

  Widget _buildEndedProfileRow(DebateInfo chatState, bool isOwner) {
    final endedInfo = ref.read(endedProvider);
    return isOwner
        ? Row(
            children: [
              Column(
                children: [
                  _buildProfileImage(
                      endedInfo!.debateJoinerImageUrl, ColorSystem.voteBlue),
                  SizedBox(height: 1.h),
                  Text(
                    endedInfo.debateJoinerName,
                    style: FontSystem.KR14SB,
                  ),
                ],
              ),
              SizedBox(
                width: 8.w,
              ),
              Container(
                width: 140.w,
                child: Text(
                  endedInfo.debateJoinerOpinion,
                  style: FontSystem.KR14M,
                  maxLines: null,
                  softWrap: true,
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  endedInfo!.debateMakerOpinion,
                  style: FontSystem.KR14M,
                  textAlign: TextAlign.end,
                  maxLines: null,
                  softWrap: true,
                ),
              ),
              SizedBox(
                width: 8.w,
              ),
              Column(
                children: [
                  _buildProfileImage(
                      endedInfo.debateOwnerImageUrl, ColorSystem.voteRed),
                  SizedBox(height: 1.h),
                  Text(
                    endedInfo.debateOwnerName,
                    style: FontSystem.KR14SB,
                  ),
                ],
              ),
            ],
          );
  }

  Widget _buildProfileImage(String imageUrl, Color borderColor) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 4.0,
        ),
      ),
      child: imageUrl.isNotEmpty
          ? CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 30,
              backgroundImage: NetworkImage(imageUrl),
            )
          : SvgPicture.asset(
              'assets/icons/basicProfile.svg',
              width: 60,
              height: 60,
            ),
    );
  }

  Widget _buildProfileHeader(WidgetRef ref) {
    final chatState = ref.read(chatInfoProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
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

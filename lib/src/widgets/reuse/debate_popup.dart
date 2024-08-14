import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:tito_app/core/provider/debate_create_provider.dart';
import 'package:tito_app/core/provider/userProfile_provider.dart';
import 'package:tito_app/core/provider/websocket_provider.dart';
import 'package:tito_app/src/viewModel/popup_viewModel.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

String selectedDebate = '';

class DebatePopup extends ConsumerStatefulWidget {
  const DebatePopup({super.key});

  @override
  _DebatePopupState createState() => _DebatePopupState();
}

class _DebatePopupState extends ConsumerState<DebatePopup> {
  @override
  Widget build(BuildContext context) {
    final popupState = ref.watch(popupProvider);
    final chatState = ref.read(chatInfoProvider);

    return Dialog(
      backgroundColor: ColorSystem.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        width: 280.w,
        height: 300.h,
        padding:
            EdgeInsets.only(top: 12.h, left: 16.w, right: 16.w),    // 팝업 안의 전체 내용 패딩 부분
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 상단 제목 및 닫기 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 45.w,
                ),
                popupState.buttonStyle == 2
                    ? Row(
                        children: [
                          if (popupState.imgSrc != null)
                            SvgPicture.asset(
                              popupState.imgSrc!,
                              width: 40.w,
                              height: 40.h,
                            ),
                          Text(popupState.titleLabel ?? '',
                              style: FontSystem.KR18SB),
                        ],
                      )
                    : popupState.imgSrc != null
                        ? SvgPicture.asset(
                            popupState.imgSrc!,
                            width: 40.w,
                            height: 40.h,
                          )
                        : Container(),
                IconButton(
                  iconSize: 25,
                  icon: const Icon(Icons.close),
                  onPressed: () => context.pop(),
                ),
              ],
            ),
            SizedBox(height: 16.h), // 팝업 아이콘과 팝업 제목 간 간격
            Text(popupState.title ?? '', style: FontSystem.KR18SB),
            SizedBox(height: 20.h), // 팝업 제목 과 팝업 내용컨테이너 간 간격
            popupState.title == '토론의 승자를 투표해주세요!'
                ? Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDebate = chatState.debateOwnerNick;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: selectedDebate ==
                                              chatState!.debateOwnerNick
                                          ? ColorSystem.purple
                                          : ColorSystem.grey3,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        chatState.debateJoinerPicture,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      chatState.debateOwnerNick,
                                      style: FontSystem.KR14M,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              decoration: BoxDecoration(
                                color: ColorSystem.black,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'VS',
                                style: FontSystem.KR16SB
                                    .copyWith(color: ColorSystem.white),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDebate = chatState.debateJoinerNick;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: selectedDebate ==
                                              chatState.debateJoinerNick
                                          ? ColorSystem.purple
                                          : ColorSystem.grey3,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        chatState.debateOwnerPicture,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      chatState.debateJoinerNick,
                                      style: FontSystem.KR14M,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  )
                : Container(
                    // 팝업 창 안 내용 부분
                    width: 248.w,
                    height: 100.h,
                    alignment: Alignment.center, // 컨테이너 안에서 중앙 정렬
                    decoration: BoxDecoration(
                        color: ColorSystem.ligthGrey,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: ColorSystem.grey3,
                        )),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 22.h),
                      child: Text(
                        popupState.content ?? '',
                        textAlign: TextAlign.center,
                        style: FontSystem.KR14R,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),   // 팝업 내용과 팝업 버튼 간 간격
            if (popupState.buttonStyle == 2)
              _twoButtons(context, ref)
            else if (popupState.buttonStyle == 1)
              _oneButton(context, ref),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _oneButton(BuildContext context, WidgetRef ref) {
    final popupState = ref.watch(popupProvider);
    final popupViewModel = ref.watch(popupProvider.notifier);
    final debateState = ref.watch(debateCreateProvider);
    final chatViewModel = ref.watch(chatInfoProvider.notifier);

// 팝업창 보라색 버튼 부분

    return Container(
      width: 200.w,
      height: 40.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorSystem.purple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onPressed: () async {
          if (popupState.title == '토론에 참여 하시겠어요?') {
            ref.read(popupProvider.notifier).state = popupState.copyWith(
              buttonStyle: 0,
              title: '토론이 시작 됐어요! 🎵',
              content: '서로 존중하는 토론을 부탁드려요!',
            );
            context.pop();
            await Future.delayed(
                Duration(milliseconds: 100)); // ensure popup has closed
            // popupViewModel.showDebatePopup(context);
          } else if (popupState.title == '토론의 승자를 투표해주세요!') {
            print(selectedDebate);
            chatViewModel.sendVote(selectedDebate);
          } else if (popupState.title == '토론 시작 시 알림을 보내드릴게요!') {
            context.pop();
          }
        },
        child: Text(
          // " 네 알겠어요 " 같은 확인 버튼 텍스트 부분
          popupState.buttonContentLeft!,
          style: FontSystem.KR14SB.copyWith(color: ColorSystem.white),
        ),
      ),
    );
  }

  Widget _twoButtons(BuildContext context, WidgetRef ref) {
    final popupState = ref.watch(popupProvider);
    final popupViewModel = ref.watch(popupProvider.notifier);
    final debateState = ref.watch(debateCreateProvider);
    final chatViewModel = ref.watch(chatInfoProvider.notifier);
    final chatState = ref.watch(chatInfoProvider);
    final userState = ref.watch(userProfileProvider);

    void startDebate() async {
      try {
        if (debateState.debateImageUrl == '') {
          final debateData = debateState.toJson();

          var formData = FormData.fromMap({
            'debate': MultipartFile.fromString(
              jsonEncode(debateData),
              contentType: DioMediaType.parse("application/json"),
            ),
          });
          final response = await ApiService(DioClient.dio).postDebate(formData);
          debateState.debateContent = '';

          context.push('/chat/${response.id}');
        } else {
          final debateData = debateState.toJson();

          File debateImage = File(debateState.debateImageUrl);
          var formData = FormData.fromMap({
            'debate': MultipartFile.fromString(
              jsonEncode(debateData),
              contentType: DioMediaType.parse("application/json"),
            ),
            'file': await MultipartFile.fromFile(
              debateImage.path,
              filename: debateImage.path.split(Platform.pathSeparator).last,
            ),
          });
          // Print the form data fields
          formData.fields.forEach((field) {
            print('Field: ${field.key} = ${field.value}');
          });

          // Print the form data files
          formData.files.forEach((file) {
            print('File: ${file.key} = ${file.value.filename}');
            print('File path: ${debateImage.path}');
          });
          final response = await ApiService(DioClient.dio).postDebate(formData);
          debateState.debateContent = '';
          debateState.debateImageUrl = '';

          context.push('/chat/${response.id}');
        }
      } catch (error) {
        print('Error posting debate: $error');
      }
    }

    void deleteDebate() async {
      final chatState = ref.read(chatInfoProvider);

      try {
        await ApiService(DioClient.dio).deleteDebate(chatState!.id);
        ref.read(popupProvider.notifier).state = popupState.copyWith(
          buttonStyle: 0,
        );

        context.pop();
        await Future.delayed(
            Duration(milliseconds: 100)); // ensure popup has closed
        context.go('/home');
      } catch (error) {
        print('Error posting debate: $error');
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: ColorSystem.white,
              backgroundColor: ColorSystem.popupLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.h),
            ),
            onPressed: () {
              if (popupState.title == '상대방이 타이밍 벨을 울렸어요!') {
                chatViewModel.timingNOResponse();
              }
              context.pop();  
            },
            child: Text(
              popupState.buttonContentLeft ?? '',
              style: FontSystem.KR14SB.copyWith(color: ColorSystem.purple), //팝업 버튼 중 2개중 왼쪽버튼글씨
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorSystem.purple,  //팝업 아래 2개 버튼 중 오른쪽 버튼 색깔
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.h),
            ),
            onPressed: () {
              if (popupState.title == '토론장을 개설하시겠어요?') {
                startDebate();
              } else if (popupState.title == '토론을 삭제 하시겠어요?') {
                deleteDebate();
              } else if (popupState.title == '정말 토론을 끝내시려구요?') {
                chatViewModel.timingSend();
                context.pop();
              } else if (popupState.title == '상대방이 타이밍 벨을 울렸어요!') {
                chatViewModel.timingOKResponse();
                context.pop();
              } else if (popupState.title == '차단 하시겠어요?') {
                popupViewModel.postBlock(userState!.id);
                context.pop();
              } else {
                context.pop();
                Future.delayed(
                    Duration(milliseconds: 100)); // ensure popup has closed
                popupViewModel.showDebatePopup(context);
              }
            },
            child: Text(
              popupState.buttonContentRight ?? '',
              style: FontSystem.KR14SB.copyWith(color: ColorSystem.white),  // 팝업 버튼 2개 중 오른쪽 버튼 글씨
            ),
          ),
        ),
      ],
    );
  }
}

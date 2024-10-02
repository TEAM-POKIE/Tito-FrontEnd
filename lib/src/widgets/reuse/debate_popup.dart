import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:tito_app/core/provider/debate_create_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/userProfile_provider.dart';
import 'package:tito_app/core/api/dio_client.dart';
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
        //height: 300.h
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 45.w,
                ),
                Row(
                  children: [
                    if (popupState.imgSrc != null)
                      SvgPicture.asset(
                        popupState.imgSrc!,
                        width: 40.w,
                        height: 40.h,
                      ),
                    if (popupState.buttonStyle == 2 &&
                        popupState.titleLabel != null)
                      SizedBox(width: 8.w),
                    if (popupState.buttonStyle == 2)
                      Text(
                        popupState.titleLabel ?? '',
                        style: FontSystem.KR16SB,
                      ),
                  ],
                ),
                IconButton(
                  iconSize: 20,
                  icon: const Icon(Icons.close, color: ColorSystem.grey),
                  onPressed: () => context.pop(),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(popupState.title ?? '', style: FontSystem.KR16SB),
            SizedBox(height: 20.h),
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
                                  selectedDebate = chatState.debateJoinerNick;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: selectedDebate ==
                                              chatState!.debateJoinerNick
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
                                    const SizedBox(height: 8),
                                    Text(
                                      chatState.debateJoinerNick,
                                      style: FontSystem.KR14M,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
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
                                  selectedDebate = chatState.debateOwnerNick;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: selectedDebate ==
                                              chatState.debateOwnerNick
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
                                    const SizedBox(height: 8),
                                    Text(
                                      chatState.debateOwnerNick,
                                      style: FontSystem.KR14M,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  )
                : Container(
                    width: 248.w,
                    alignment: Alignment.center,
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
            SizedBox(height: 20.h),
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
    final chatViewModel = ref.watch(chatInfoProvider.notifier);

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
          final loginInfo = ref.read(loginInfoProvider);
          if (popupState.title == '토론에 참여하시겠습니까?') {
            if (loginInfo!.tutorialCompleted == true) {
              ref.read(popupProvider.notifier).state = popupState.copyWith(
                buttonStyle: 0,
                title: '토론이 시작 됐어요! 🎵',
                content: '서로 존중하는 토론을 부탁드려요!',
              );
              context.pop();
              await Future.delayed(const Duration(milliseconds: 100));
              popupViewModel.showDebatePopup(context);
            } else {
              context.pop();
            }
          } else if (popupState.title == '토론의 승자를 투표해주세요!') {
            chatViewModel.sendVote(
              selectedDebate,
            );
            context.pop();
          } else if (popupState.title == '토론 시작 시 알림을 보내드릴게요!') {
            context.pop();
          }
        },
        child: Text(
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
    final userState = ref.watch(userProfileProvider);
    final progressNoti = ref.watch(progressProvider.notifier);

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
          debateState.debateTitle = '';
          debateState.debateMakerOpinion = '';
          debateState.debateJoinerOpinion = '';
          debateState.debateImageUrl = '';
          progressNoti.resetProgress();
          context.go('/chat/${response.id}');
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
        await Future.delayed(const Duration(milliseconds: 100));
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
              style: FontSystem.KR14SB
                  .copyWith(color: ColorSystem.purple), //팝업 버튼 중 2개중 왼쪽버튼글씨
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorSystem.purple, //팝업 아래 2개 버튼 중 오른쪽 버튼 색깔
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
                Future.delayed(const Duration(milliseconds: 100));
                popupViewModel.showDebatePopup(context);
              }
            },
            child: Text(
              popupState.buttonContentRight ?? '',
              style: FontSystem.KR14SB
                  .copyWith(color: ColorSystem.white), // 팝업 버튼 2개 중 오른쪽 버튼 글씨
            ),
          ),
        ),
      ],
    );
  }
}

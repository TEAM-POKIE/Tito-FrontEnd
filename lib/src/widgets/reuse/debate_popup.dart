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
import 'package:tito_app/core/provider/userProfile_provider.dart';
import 'package:tito_app/core/provider/websocket_provider.dart';
import 'package:tito_app/src/viewModel/popup_viewModel.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DebatePopup extends ConsumerWidget {
  const DebatePopup({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popupState = ref.watch(popupProvider);

    return Dialog(
      backgroundColor: ColorSystem.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 13.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                              style: FontSystem.KR14SB),
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
            const SizedBox(height: 10),
            Text(
              popupState.title ?? '',
              style: FontSystem.KR18SB
            ),
            SizedBox(height: 20.h),
            Container(
              width: 248.w,
              height: 100.h,
              padding: EdgeInsets.symmetric(vertical: 20.h),
              decoration: BoxDecoration(
                color: ColorSystem.ligthGrey,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: ColorSystem.grey3
                )
              ),
              child: Text(
                popupState.content ?? '',
                textAlign: TextAlign.center,
                style: FontSystem.KR14R,
              ),
            ),
            const SizedBox(height: 25),
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
              imgSrc: 'assets/icons/popup_face.svg',
              content: '서로 존중하는 토론을 부탁드려요!',
            );
      
            context.pop();
            await Future.delayed(
                Duration(milliseconds: 100)); // ensure popup has closed
            // popupViewModel.showDebatePopup(context);
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

    void startDebate() async {
      try {
        if (debateState.debateImageUrl == '') {
          final debateData = debateState.toJson();
          print(debateData);
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
              backgroundColor: ColorSystem.purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onPressed: () {
              if (popupState.title == '상대방이 타이밍 벨을 울렸어요!') {
                chatViewModel.timingNOResponse();
              }
              context.pop();
            },
            child: Text(
              popupState.buttonContentLeft ?? '',
              style: FontSystem.KR12B.copyWith(color: ColorSystem.white),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorSystem.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onPressed: () {
              if (popupState.title == '토론장을 개설하겠습니까?') {
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
              } else {
                context.pop();
                Future.delayed(
                    Duration(milliseconds: 100)); // ensure popup has closed
                popupViewModel.showDebatePopup(context);
              }
            },
            child: Text(
              popupState.buttonContentRight ?? '',
              style: FontSystem.KR12B.copyWith(color: ColorSystem.white),
            ),
          ),
        ),
      ],
    );
  }
}

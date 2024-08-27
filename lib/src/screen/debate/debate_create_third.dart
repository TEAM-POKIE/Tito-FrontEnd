import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/debate_create_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DebateCreateThird extends ConsumerStatefulWidget {
  const DebateCreateThird({super.key});

  @override
  ConsumerState<DebateCreateThird> createState() => _DebateCreateThirdState();
}

class _DebateCreateThirdState extends ConsumerState<DebateCreateThird> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();

    final debateState = ref.read(debateCreateProvider);
    _contentController = TextEditingController(text: debateState.debateContent);
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final debateViewModel = ref.watch(debateCreateProvider.notifier);
    final debateState = ref.watch(debateCreateProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 키보드 닫기
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorSystem.white,
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: SvgPicture.asset('assets/icons/back_arrow.svg'),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 24.w),
                  child: LinearPercentIndicator(
                    width: 210.w,
                    animation: true,
                    animationDuration: 1000,
                    lineHeight: 5.0,
                    percent: 1,
                    linearStrokeCap: LinearStrokeCap.butt,
                    progressColor: ColorSystem.purple,
                    backgroundColor: ColorSystem.grey,
                    barRadius: Radius.circular(10.r),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 34.h),
                  Text(
                    debateState.debateTitle,
                    style: FontSystem.KR18B.copyWith(fontSize: 30),
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    '토론 주제에 대한 본문',
                    style: FontSystem.KR18SB,
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    width: 350.w,
                    height: 240.h,
                    decoration: BoxDecoration(
                        color: ColorSystem.ligthGrey,
                        borderRadius: BorderRadius.circular(10.r)),
                    child: TextFormField(
                      controller: _contentController,
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: '입력하세요',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '본문을 입력하세요';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        debateViewModel.updateContent(value ?? '');
                      },
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    '이미지 첨부하기',
                    style: FontSystem.KR18SB,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 115.w,
                        height: 45.h,
                        child: TextButton.icon(
                          onPressed: () {
                            debateViewModel.pickImage();
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                            color: ColorSystem.white,
                          ),
                          label: Text(
                            '파일 첨부',
                            style: FontSystem.KR14M
                                .copyWith(color: ColorSystem.white),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: ColorSystem.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20.w), // 간격을 일정하게 유지
                      if (debateState.debateImageUrl != null &&
                          File(debateState.debateImageUrl).existsSync())
                        Stack(
                          children: [
                            Container(
                              // width: 100.w, // 이미지 크기 고정
                              height: 100.h, // 이미지 크기 고정
                              child: Image.file(
                                File(debateState.debateImageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    debateState.debateImageUrl = 'null';
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: ColorSystem.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: ColorSystem.white,
                                    size: 15.w,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          child: SizedBox(
            width: 350.w,
            height: 60.h,
            child: ElevatedButton(
              onPressed: () {
                debateViewModel.nextChat(_formKey, context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorSystem.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              child: Text(
                '토론장으로 이동',
                style: TextStyle(fontSize: 20.sp, color: ColorSystem.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

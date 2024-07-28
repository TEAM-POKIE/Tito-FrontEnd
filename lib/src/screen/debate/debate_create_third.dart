import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/debate_create_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';


class DebateCreateThird extends ConsumerWidget {
  const DebateCreateThird({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    final debateViewModel = ref.watch(debateCreateProvider.notifier);
    final debateState = ref.watch(debateCreateProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss keyboard
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.pop();
              //바로 이전에 실행했던 화면으로 이동
            },
            icon: const Icon(Icons.arrow_back_ios),
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
                  const Text(
                    '토론 주제에 대한 본문',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    autocorrect: false,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: '입력하세요',
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '본문을 입력하세요';
                      }
                      return null;
                    },
                    // onSaved: (value) {
                    //   debateViewModel.updateContent(value ?? '');
                    // },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '이미지 첨부하기',
                    style: FontSystem.KR18R.copyWith(color: ColorSystem.black),
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {}, //debateViewModel.pickImage,
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
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                debateViewModel.nextChat(_formKey, context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff8E48F8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text(
                '다음',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

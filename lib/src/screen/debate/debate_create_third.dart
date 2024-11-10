import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/debate_create_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                    height: 250.h,
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: ColorSystem.ligthGrey,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        child: TextFormField(
                          controller: _contentController,
                          keyboardType: TextInputType.multiline,
                          autocorrect: false,
                          expands: true,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText:
                                '티토는 누구나 기분 좋게 참여할 수 있는 커뮤니티를 만들기 위해 커뮤니티 이용규칙을 제정하여 운영하고 있습니다. '
                                '위반 시 게시물이 삭제되고 서비스 이용이 일정 기간 제한될 수 있습니다. 아래는 이 게시판에 해당하는 핵심 내용에 대한 요약 사항이며, '
                                '게시물 작성 전 커뮤니티 이용규칙 전문을 반드시 확인하시기 바랍니다.\n\n'
                                '※ 홍보 및 판매 관련 행위 금지\n'
                                '- 영리 여부와 관계 없이 사업체·기관·단체·개인에게 직간접적으로 영향을 줄 수 있는 게시물 작성 행위\n'
                                '- 위와 관련된 것으로 의심되거나 예상될 수 있는 바이럴 홍보 및 명칭·단어 언급 행위\n'
                                '* 해당 게시물은 홍보게시판에만 작성 가능합니다.\n\n'
                                '※ 불법촬영물 유통 금지\n'
                                '불법촬영물등을 게재할 경우 전기통신사업법에 따라 삭제 조치 및 서비스 이용이 영구적으로 제한될 수 있으며 관련 법률에 따라 처벌받을 수 있습니다.\n\n'
                                '※ 그 밖의 규칙 위반\n'
                                '- 타인의 권리를 침해하거나 불쾌감을 주는 행위\n'
                                '- 범죄, 불법 행위 등 법령을 위반하는 행위\n'
                                '- 욕설, 비하, 차별, 혐오, 자살, 폭력 관련 내용을 포함한 게시물 작성 행위\n'
                                '- 음란물, 성적 수치심을 유발하는 행위\n'
                                '- 스포일러, 공포, 속임, 놀라게 하는 행위',
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

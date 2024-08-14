import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RulePopUp extends ConsumerWidget {
  const RulePopUp({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      backgroundColor: ColorSystem.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        width: 350.w,
        height: 580.h,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 35.w),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/purple_rule.svg',
                      width: 30.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.w),
                      child: Text(
                        '토론 룰',
                        style: FontSystem.KR14B,
                      ),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: const Divider(
                color: ColorSystem.grey3,
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.w),
                  child: Column(
                    children: [
                      _buildRuleItem(
                        context,
                        '⏳  한 사람당 발언 시간은 8분입니다.',
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: const Divider(
                          color: ColorSystem.grey3,
                        ),
                      ),
                      _buildRuleItem(
                        context,
                        '⏳  8분이 지나면 자동으로 채팅이 전송되니\n 대답 제한 시간이 끝나기 전까지 의견을 작성해주세요.',
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: const Divider(
                          color: ColorSystem.grey3,
                        ),
                      ),
                      _buildRuleItem(
                        context,
                        '💭  토론 참여자 각각 3번의 발언 진행 후,\n 최종 변론 타이밍 벨이 활성화 됩니다.',
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: const Divider(
                          color: ColorSystem.grey3,
                        ),
                      ),
                      _buildRuleItem(
                        context,
                        '💭  2회 무응답시 기권패로 토론이 종료됩니다.',
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: const Divider(
                          color: ColorSystem.grey3,
                        ),
                      ),
                      _buildRuleItem(
                        context,
                        '🔔  타이밍벨이 울리기 전까지 자유롭게 의견을\n 나눠보세요!',
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: const Divider(
                          color: ColorSystem.grey3,
                        ),
                      ),
                      _buildRuleItem(
                        context,
                        '🚨  규칙 위반 행위 시 신고 가능합니다.',
                      ),
                      _buildViolationItem(
                        context,
                        '-  타인의 권리를 침해하거나 불쾌감을 주는 행위\n-  법적, 불법 행위 등 법령을 위반하는 행위\n-  욕설, 비하, 협박, 자살, 폭력 관련 내용을 포함한\n   게시물 작성 행위\n-  음란물, 성적 수치심을 유발하는 행위\n-  스팸링크, 광고, 수익, 논란이 되는 행위',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleItem(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: FontSystem.KR14R,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViolationItem(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Padding(
        padding: EdgeInsets.only(left: 15.w),
        child: Row(
            
          children: [
            Expanded(
              child: Text(
                text,
                style: FontSystem.KR14R,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

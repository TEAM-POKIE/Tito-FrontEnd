import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:go_router/go_router.dart';

class RulePopUp extends ConsumerWidget {
  const RulePopUp({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 35),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/ruleBookIcon.png',
                      width: 30,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '토론 룰',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  iconSize: 25,
                  icon: const Icon(Icons.close),
                  onPressed: () => context.pop(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildRuleItem(
                      context,
                      '⏳ 한 사람당 발언 시간은 8분입니다.',
                    ),
                    _buildRuleItem(
                      context,
                      '⏳ 8분이 지나면 자동으로 채팅이 전송되니 대답 제한 시간이 끝나기 전까지 의견을 작성해주세요.',
                    ),
                    _buildRuleItem(
                      context,
                      '💭 토론 참여자 각각 3번의 발언 진행 후, 최종 변론 타이밍 벨이 활성화 됩니다.',
                    ),
                    _buildRuleItem(
                      context,
                      '💭 2회 무응답시 기권패로 토론이 종료됩니다.',
                    ),
                    _buildRuleItem(
                      context,
                      '🔔 타이밍벨이 울리기 전까지 자유롭게 의견을 나눠보세요!',
                    ),
                    const Divider(),
                    _buildRuleItem(
                      context,
                      '🚨 규칙 위반 행위 시 신고 가능합니다.',
                    ),
                    _buildViolationItem(
                      context,
                      '- 타인의 권리를 침해하거나 불쾌감을 주는 행위\n- 법적, 불법 행위 등 법령을 위반하는 행위\n- 욕설, 비하, 협박, 자살, 폭력 관련 내용을 포함한 게시물 작성 행위\n- 음란물, 성적 수치심을 유발하는 행위\n- 스팸링크, 광고, 수익, 논란이 되는 행위',
                    ),
                  ],
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 10),
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 10),
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
}

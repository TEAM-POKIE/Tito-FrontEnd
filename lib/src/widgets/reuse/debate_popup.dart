import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:tito_app/core/constants/style.dart';

class DebatePopup extends ConsumerWidget {
  final String? debateId;
  final String? nick;
  final Function? onUpdate;
  final String title;
  final String content;
  final bool doubleButton; // 수정: nullable 제거

  DebatePopup({
    this.debateId,
    this.nick,
    this.onUpdate,
    this.doubleButton = false, // 기본값 설정
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Icon(Icons.person, color: Colors.grey),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              textAlign: TextAlign.center,
              style: FontSystem.KR14R,
            ),
            const SizedBox(height: 20),
            if (doubleButton) _twoButtons() else _oneButton(), // 조건부 렌더링
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _oneButton extends StatelessWidget {
  const _oneButton({super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(
        '토론 참여하기',
        style: FontSystem.KR12B.copyWith(color: ColorSystem.purple),
      ),
    );
  }
}

class _twoButtons extends StatelessWidget {
  const _twoButtons({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text(
            '버튼 1',
            style: FontSystem.KR12B.copyWith(color: ColorSystem.purple),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {},
          child: Text(
            '버튼 2',
            style: FontSystem.KR12B.copyWith(color: ColorSystem.purple),
          ),
        ),
      ],
    );
  }
}

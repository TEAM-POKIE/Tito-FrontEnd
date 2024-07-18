import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/constants/style.dart';

void showExitDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/chatIconRight.png',
                      width: 50, height: 50),
                  //const SizedBox(width: 50),
                  // IconButton(
                  //   icon: const Icon(Icons.close),
                  //   onPressed: () => context.pop(),
                  // ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                '정말로 회원 탈퇴 하시겠습니까?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 250,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '회원탈퇴 시\n토론 기록과 관련 정보들이\n영영 사라져요',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 250,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorSystem.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                    child: Text('회원 탈퇴 하기',
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // 로그아웃 처리 코드 추가
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

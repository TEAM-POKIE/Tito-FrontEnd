import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';

class ChatLlm extends ConsumerStatefulWidget {
  const ChatLlm({super.key});

  @override
  _ChatLlmState createState() => _ChatLlmState();
}

class _ChatLlmState extends ConsumerState<ChatLlm> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatInfoProvider);

    return Padding(
      padding: EdgeInsets.only(
        right: 30.w,
        left: 30.w,
        top: 41.h,
      ), // Bottom padding 조정
      child: ListView(
        controller: _scrollController,
        physics: ClampingScrollPhysics(),
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/blackLLM.svg',
                width: 20.w,
                height: 18.h,
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '티토가 수정해봤어요!',
                    style: FontSystem.KR16B.copyWith(color: ColorSystem.purple),
                  ),
                  Text(
                    '내용을 수정해서 채팅에 반영해보세요!',
                    style: FontSystem.KR10SB.copyWith(color: ColorSystem.grey),
                  ),
                ],
              ),
              Spacer(),
              SvgPicture.asset(
                'assets/icons/panelChatCopyIcon.svg',
                width: 12.w,
                height: 12.h,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                '채팅에 반영',
                style: FontSystem.KR13SB.copyWith(color: ColorSystem.grey1),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            chatState!.contentEdited,
            style: FontSystem.KR16M.copyWith(color: ColorSystem.black),
          ),
          SizedBox(
            height: 10.h,
          ),
          if (chatState.explanation != null)
            ...chatState.explanation!.asMap().entries.map((entry) {
              int index = entry.key + 1; // 인덱스는 1부터 시작하도록 설정
              String explanation = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h), // 여백 조정
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$index. $explanation',
                      style:
                          FontSystem.KR16M.copyWith(color: ColorSystem.purple),
                      softWrap: true, // 텍스트가 가로 공간에 맞게 줄 바꿈되도록 설정
                    ),
                    Text(
                      '$index. $explanation',
                      style:
                          FontSystem.KR16M.copyWith(color: ColorSystem.purple),
                      softWrap: true, // 텍스트가 가로 공간에 맞게 줄 바꿈되도록 설정
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            }).toList()
          else
            Text('No explanation available'),
        ],
      ),
    );
  }
}

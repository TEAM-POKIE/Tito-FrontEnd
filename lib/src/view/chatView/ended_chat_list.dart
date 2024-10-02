import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:tito_app/core/provider/ended_provider.dart';
import 'package:tito_app/src/data/models/ended_chat.dart';
import 'package:tito_app/src/data/models/ended_chatList.dart';
import 'package:tito_app/src/viewModel/chat_viewModel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EndedChatList extends ConsumerStatefulWidget {
  final int id;

  EndedChatList({
    super.key,
    required this.id,
  });

  @override
  _EndedChatListState createState() => _EndedChatListState();
}

class _EndedChatListState extends ConsumerState<EndedChatList> {
  List<EndedChatingList> messages = []; // EndedChatInfo -> EndedChatingList로 변경
  int? myUserId;

  @override
  void initState() {
    super.initState();
    _fetchChatData();
  }

  Future<void> _fetchChatData() async {
    try {
      final endedViewModel = ref.read(endedProvider.notifier);
      await endedViewModel.fetchEndedDebateInfo(widget.id);
      final response = await endedViewModel.getChat(widget.id);

      if (response.isNotEmpty) {
        setState(() {
          messages = response;
          myUserId = messages.first.userId;
        });
      }
    } catch (e) {
      print('Failed to load chat: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final endedState = ref.read(endedProvider);
    final chatViewModel = ref.read(chatInfoProvider.notifier);
    return Column(
      children: [
        Expanded(
          child: messages.isEmpty
              ? Center(child: Text("No chat messages yet"))
              : ListView.builder(
                  controller: ScrollController(),
                  itemCount: messages.length + 1, // +1 for the ending message
                  itemBuilder: (context, index) {
                    if (index == messages.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Center(
                          child: Text(
                            '토론이 종료되었습니다.',
                            style: FontSystem.KR14R
                                .copyWith(color: ColorSystem.grey1),
                          ),
                        ),
                      );
                    }

                    final message = messages[index];
                    final isMyMessage =
                        message.userId == endedState!.debateOwnerId;
                    final formattedTime = TimeOfDay.fromDateTime(
                      DateTime.parse(message.createdAt),
                    ).format(context);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: isMyMessage
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!isMyMessage)
                            IconButton(
                              onPressed: () {
                                chatViewModel.getProfile(
                                    endedState.debateJoinerId, context);
                              },
                              icon: CircleAvatar(
                                backgroundImage:
                                    endedState.debateJoinerImageUrl != null &&
                                            endedState
                                                .debateJoinerImageUrl.isNotEmpty
                                        ? NetworkImage(
                                            endedState.debateJoinerImageUrl)
                                        : null,
                                radius: 20.r,
                                child: endedState.debateJoinerImageUrl ==
                                            null ||
                                        endedState.debateJoinerImageUrl.isEmpty
                                    ? SvgPicture.asset(
                                        'assets/icons/basicProfile.svg')
                                    : null,
                              ),
                            ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: isMyMessage
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              if (!isMyMessage)
                                Container(
                                  constraints: BoxConstraints(maxWidth: 250),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: ColorSystem.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                      bottomLeft: Radius.circular(4),
                                    ),
                                  ),
                                  child: Text(
                                    message.content,
                                    style: FontSystem.KR14R,
                                  ),
                                ),
                              if (isMyMessage)
                                Container(
                                  constraints: BoxConstraints(maxWidth: 250),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: ColorSystem.purple,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                      bottomRight: Radius.circular(4),
                                      bottomLeft: Radius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    message.content,
                                    style: FontSystem.KR14R.copyWith(
                                      color: ColorSystem.white,
                                    ),
                                  ),
                                ),
                              SizedBox(height: 8),
                              Text(
                                formattedTime,
                                style: FontSystem.KR12R
                                    .copyWith(color: ColorSystem.grey1),
                              ),
                            ],
                          ),
                          if (isMyMessage) SizedBox(width: 10),
                          if (isMyMessage)
                            IconButton(
                              onPressed: () {
                                chatViewModel.getProfile(
                                    endedState.debateOwnerId, context);
                              },
                              icon: CircleAvatar(
                                backgroundImage:
                                    endedState.debateOwnerImageUrl != null &&
                                            endedState
                                                .debateOwnerImageUrl.isNotEmpty
                                        ? NetworkImage(
                                            endedState.debateOwnerImageUrl)
                                        : null,
                                radius: 20.r,
                                child: endedState.debateOwnerImageUrl == null ||
                                        endedState.debateOwnerImageUrl.isEmpty
                                    ? SvgPicture.asset(
                                        'assets/icons/basicProfile.svg')
                                    : null,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

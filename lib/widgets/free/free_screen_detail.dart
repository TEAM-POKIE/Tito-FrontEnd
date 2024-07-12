import 'package:flutter/material.dart';
import 'package:tito_app/models/freescreen_item.dart';
import 'package:tito_app/widgets/free/vote.dart';

class FreeScreenDetail extends StatelessWidget {
  final FreeScreenItem item;
  //final String postId;

  FreeScreenDetail({required this.item});

  String timeAgo(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);

    if (duration.inDays > 1) {
      return '${duration.inDays}일 전';
    } else if (duration.inDays == 1) {
      return '어제';
    } else if (duration.inHours > 1) {
      return '${duration.inHours}시간 전';
    } else if (duration.inHours == 1) {
      return '한 시간 전';
    } else if (duration.inMinutes > 1) {
      return '${duration.inMinutes}분 전';
    } else if (duration.inMinutes == 1) {
      return '1분 전';
    } else if (duration.inSeconds >= 0) {
      return '방금 전';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                      fontSize: 23, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  timeAgo(item.timestamp),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            const Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/usericon.png'),
                  radius: 13.0,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text('타카'),
              ],
            ),
            const SizedBox(height: 10.0),
            const Divider(),
            const SizedBox(height: 15.0),
            Text(
              item.content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40.0),
            const Row(
              children: [
                const Text(
                  '좋아요',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(width: 4),
                Text('12'),
                const SizedBox(width: 16),
                const Text('조회수', style: TextStyle(color: Colors.grey)),
                const SizedBox(width: 4),
                Text('32'),
                Spacer(),
                //Icon(Icons.favorite_border),
              
              ],
            ),
          ],
        ),
      ),
    );
  }
}

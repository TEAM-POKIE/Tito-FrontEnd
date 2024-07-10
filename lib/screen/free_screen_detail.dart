import 'package:flutter/material.dart';
import 'package:tito_app/widgets/free/vote.dart';

class FreeScreenDetail extends StatelessWidget {
  final String post;

  // 생성자를 통해 post 데이터를 받아옴
  const FreeScreenDetail({Key? key, required this.post}) : super(key: key);

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
                  '애인의 우정 여행 어떻게 생각해??',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const Spacer(),
                Text(
                  '5분 전',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 20.0),
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
            SizedBox(height: 15.0),
            Container(
              height: 1.0,
              color: Colors.grey[300],
            ),
            const SizedBox(
              height: 30.0,
            ),
            Text('연애중에 고민이 생겼어\n사귄지 1년 정도 됐는데 애인이 우정 여행을 간다는데'),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Vote()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

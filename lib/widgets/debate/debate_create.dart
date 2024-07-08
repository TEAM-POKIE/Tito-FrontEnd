import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebateCreate extends StatefulWidget {
  const DebateCreate({super.key});

  @override
  State<DebateCreate> createState() => _DebateCreateState();
}

class _DebateCreateState extends State<DebateCreate> {
  int selectedIndex = 0;
  final List<String> labels = ['연애', '정치', '연예', '자유', '스포츠'];
  TextEditingController topicController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0), // 원하는 여백 크기
          child: LinearProgressIndicator(
            value: 0.5, // 0.0부터 1.0 사이의 값
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
          ), //나중에 마무리
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              '카테고리 선택',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Row(
              children: List.generate(labels.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: SizedBox(
                    width: 70,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        padding: const EdgeInsets.all(0),
                        backgroundColor: selectedIndex == index
                            ? Colors.black
                            : Colors.grey[200],
                        foregroundColor: selectedIndex == index
                            ? Colors.white
                            : const Color.fromARGB(255, 101, 101, 101),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Text(
                        labels[index],
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              '토론 주제',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: topicController,
              decoration: InputDecoration(
                hintText: '입력하세요',
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Handle AI topic generation
              },
              child: Row(
                children: [
                  Image.asset('assets/images/ai_purple.png'),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'AI 주제 생성하기',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color(0xff8E48F8),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle next action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff8E48F8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  '다음',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}

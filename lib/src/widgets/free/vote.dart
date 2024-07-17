import 'package:flutter/material.dart';

class Vote extends StatefulWidget {
  const Vote({super.key});

  @override
  _VoteState createState() => _VoteState();
}

class _VoteState extends State<Vote> {
  String _selectedOption = '신경 쓰인다고 말한다';

  void _submitVote() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('선택된 옵션: $_selectedOption'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('투표'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('참여 10명'),
            const SizedBox(height: 20),
            RadioListTile<String>(
              title: const Text('쿨하게 보내준다'),
              value: '쿨하게 보내준다',
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('신경 쓰인다고 말한다'),
              value: '신경 쓰인다고 말한다',
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('안보내주고 싸운다'),
              value: '안보내주고 싸운다',
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitVote,
              style: ElevatedButton.styleFrom(
                //primary: Color(0xFFA86BF0), // 버튼 색상
              ),
              child: const Text('투표 하기'),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class DebateCreate extends StatelessWidget {
  const DebateCreate({super.key});
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
      body: const Text('토론장 개설'),
    );
  }
}

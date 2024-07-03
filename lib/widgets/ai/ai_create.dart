import 'package:flutter/material.dart';

class AiCreate extends StatelessWidget {
  const AiCreate({super.key});
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
      body: const Text('Ai'),
    );
  }
}

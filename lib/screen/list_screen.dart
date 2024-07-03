import 'package:flutter/material.dart';
import 'package:tito_app/widgets/reuse/bottombar.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});
  @override
  State<ListScreen> createState() {
    return _ListScreenState();
  }
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('토론 리스트'),
      ),
      body: const BottomBar(),
    );
  }
}

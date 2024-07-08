import 'package:flutter/material.dart';
import 'package:tito_app/widgets/reuse/bottombar.dart';

class FreeScreen extends StatefulWidget {
  const FreeScreen({super.key});
  @override
  State<FreeScreen> createState() {
    return _FreeScreenState();
  }
}

class _FreeScreenState extends State<FreeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('??œ ê²Œì‹œ?Œ',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
      ),
      body: const Column(
        
        //BottomBar(),
      ) 
    );
  }
}

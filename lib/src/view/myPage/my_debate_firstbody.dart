import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/screen/home_screen.dart';
import 'dart:async';

class MyDebateFirstbody extends ConsumerStatefulWidget {
  const MyDebateFirstbody({super.key});

  @override
  ConsumerState<MyDebateFirstbody> createState() {
    return _MyDebateFirstbodyState();
  }
}

class _MyDebateFirstbodyState extends ConsumerState<MyDebateFirstbody> {
  final List<String> sortOptions = ['최신순', '인기순'];
  String selectedSortOption = '최신순';

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedSortOption = sortOptions[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0),
          child: Text(
            '포키님은 12번의 토론 중\n10번을 이기셨어요!',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButton<String>(
              value: selectedSortOption,
              onChanged: (String? newValue) {
                setState(() {
                  selectedSortOption = newValue!;
                });
              },
              items: sortOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),),
          ],
        ),
      ],
    );
  }
}

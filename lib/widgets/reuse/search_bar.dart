import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 360,
        child: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 207, 203, 203), // 더 밝은 배경색
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide.none),
            hintText: '검색어를 입력하세요',
            hintStyle: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 130, 130, 130),
            ),
            prefixIcon: const Icon(Icons.search,
                color: Color.fromARGB(255, 88, 88, 88),
                size: 26.0), // 아이콘 색상 추가
          ),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

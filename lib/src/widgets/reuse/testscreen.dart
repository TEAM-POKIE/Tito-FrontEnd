import 'package:flutter/material.dart';

class Testscreen extends StatelessWidget {
  const Testscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(useMaterial3: true);

    return Theme(
      data: themeData,
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: const Text('Search Bar Sample'),
        ),
        body: const Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: SearchBar(
                leading: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                constraints: BoxConstraints(
                  maxWidth: 200,
                  maxHeight: 150,
                ),
                hintText: "검색어를 입력하세요",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

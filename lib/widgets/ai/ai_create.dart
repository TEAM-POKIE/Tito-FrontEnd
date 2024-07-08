import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tito_app/widgets/ai/ai_select.dart';
import 'package:get/get.dart';
import 'package:tito_app/widgets/ai/selection_controller.dart';

class AiCreate extends StatelessWidget {
  final SelectionController selectionController = Get.put(SelectionController());

    Widget _buildGridItem(BuildContext context, String text, int index) {
    return Obx(() {
      bool isSelected = selectionController.selectedItems.contains(index);
      return InkWell(
        onTap: () => selectionController.toggleSelection(index),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: isSelected ? const Color(0xFF8E48F8) : Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(4.0),
          child: Center(
            child: Text(text),
          ),
        ),
      );
    });
  }

    Widget _buildSelectedItem(int index) {
    return Transform.scale(
      scale: 0.77,
      child: Chip(
        label: Text(
          '아이템 $index',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: Colors.black,
        deleteIcon: const Icon(Icons.close, color: Colors.white),
        onDeleted: () => selectionController.toggleSelection(index), // X 아이콘이 눌렸을 때 선택 상태 토글
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
    );
  }

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
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.all(18)),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.only(left: 18)),
                Image.asset(
                  'assets/images/ai_purple.png',
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 7),
                    Text(
                      'AI 자동 토론 주제 생성 하기',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '원하는 키워드를 선택해보세요!',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25,
            child: Obx(() {
              return selectionController.selectedItems.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 0.0, // Chip 간의 수평 간격 최소화
                          runSpacing: 0.0, // Chip 줄 간의 수직 간격 최소화
                          children: selectionController.selectedItems
                              .map((index) => _buildSelectedItem(index))
                              .toList(),
                        ),
                      ),
                    )
                  : Container();
            }),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: selectionController.resetSelection,
                child: const Text(
                  '새로고침',
                  style: TextStyle(color: Colors.black, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(9, (index) {
                  return _buildGridItem(context, '아이템 $index', index);
                }),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              bool isSelectExist = selectionController.selectedItems.isNotEmpty;
              return SizedBox(
                width: 310,
                height: 60,
                child: ElevatedButton(
                  onPressed: isSelectExist
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AiSelect()),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelectExist ? const Color(0xFF8E48F8) : Colors.grey,
                  ),
                  child: const Text(
                    '다음',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 23),
        ],
      ),
    );
  }
}
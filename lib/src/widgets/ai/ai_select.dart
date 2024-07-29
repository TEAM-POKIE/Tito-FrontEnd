import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tito_app/src/widgets/ai/ai_select.dart';
import 'package:get/get.dart';
import 'package:tito_app/src/widgets/ai/selection_controller.dart';

class AiSelect extends StatefulWidget {
  
  SelectionController selectionController = Get.put(SelectionController());
  AiSelect({super.key});


    Widget _buildGridItem(BuildContext context, String text, int index) {
    return Obx(() {
      bool isSelected = selectionController.selectedItems.contains(index);
      return InkWell(
        onTap: () => selectionController.toggleSelection(index),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: isSelected ? ColorSystem.purple : ColorSystem.grey),
            borderRadius: BorderRadius.circular(24.r),
          ),
          margin: EdgeInsets.all(4.5.w),
          child: Center(
            child: Text(text),
          ),
        ),
      );
    });
  }
  

  @override
  State<StatefulWidget> createState() {
    return _AiSelectState();
  }
}

class _AiSelectState extends State<AiSelect> {
  int _selectedIndex = -1;
  // 각 아이템의 테두리 색상을 저장할 리스트
  List<Color> borderColors =
      List<Color>.generate(9, (index) => ColorSystem.grey);
  //선택한 아이템들을 저장할 리스트
  List<int> selectedSentence = [];

  void _resetGrid() {
    setState(() {
      borderColors = List<Color>.generate(9, (index) => ColorSystem.grey);
      selectedSentence.clear();
    });
  }

  void _sentenceSelection(int index) {
    setState(() {
      if (selectedSentence.contains(index)) {
        selectedSentence.remove(index);
        borderColors[index] = ColorSystem.grey;
      } else {
        selectedSentence.add(index);
        borderColors[index] = ColorSystem.purple;
      }
    });
  }

  Widget _createSentence(BuildContext context, String text, int index) {
    return InkWell(
      onTap: () => _sentenceSelection(index),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColors[index]), // 상태에 따른 테두리 색상
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Center(
          child: Text(text),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isSelectExist = selectedSentence.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 37.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.symmetric(horizontal: 10.w)),
              Image.asset(
                'assets/images/ai_purple.png',
                width: 40.w,
                height: 40.h,
              ),
              SizedBox(
                width: 8.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  const Text(
                    'AI 자동 토론 주제 생성 하기',
                    style: FontSystem.KR18R,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '이런 주제는 어때요?',
                        style: FontSystem.KR18R,
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        '바로 다른 사람들과 의견을 나눠보세요 !',
                        style: FontSystem.KR18R,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 78.h), // 간격 추가
          Expanded(
            child: GridView.count(
              crossAxisCount: 1, // 한 줄에 3개의 아이템을 표시
              childAspectRatio: 4 / 0.75,
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              mainAxisSpacing: 11.h,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedIndex == index) {
                        _selectedIndex = -1; // 선택 해제
                      } else {
                        _selectedIndex = index; // 선택
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: _selectedIndex == index
                                ? ColorSystem.purple
                                : ColorSystem.grey),
                        borderRadius: BorderRadius.circular(20.r)),
                    alignment: Alignment.center,
                    child: Text('Item $index'),
                  ),
                );
              }),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
            child: SizedBox(
              width: 350.w,
              height: 60.h,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isSelectExist ? ColorSystem.purple : ColorSystem.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r))),
                child: Text(
                  '토론 생성',
                  style: TextStyle(color: ColorSystem.white, fontSize: 20.sp),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

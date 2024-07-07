import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AiSelect extends StatefulWidget {
  const AiSelect ({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AiSelectState();
  }
}


class _AiSelectState extends State<AiSelect> {
  int _selectedIndex = -1;
    // 각 아이템의 테두리 색상을 저장할 리스트
  List<Color> borderColors = List<Color>.generate(9, (index) => Colors.grey);
  //선택한 아이템들을 저장할 리스트
  List<int> selectedSentence = [];


  void _resetGrid() {
    setState(() {
      borderColors = List<Color>.generate(9, (index) => Colors.grey);
      selectedSentence.clear();
    });
  }

    void _sentenceSelection(int index) {
    setState(() {
      if (selectedSentence.contains(index)) {
        selectedSentence.remove(index);
        borderColors[index] = Colors.grey;
      } else {
        selectedSentence.add(index);
        borderColors[index] = const Color(0xFF8E48F8);
      }
    });
  }

    Widget _createSentence(BuildContext context, String text, int index) {
    return InkWell(
      onTap: () => _sentenceSelection(index),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColors[index]), // 상태에 따른 테두리 색상
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(4.0),
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
        leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
    ),
    body: Column(
      children: [
        const Padding(padding: EdgeInsets.all(18),),
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.only(left: 18)),
              Image.asset('assets/images/ai_purple.png',
              width: 40, height: 40,),
              const SizedBox(width: 8,),
              const Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 7,),
                Text('AI 자동 토론 주제 생성 하기',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                SizedBox(height: 8,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                    '이런 주제는 어때요?',
                    style: TextStyle(fontSize: 17),),
                    const SizedBox(height: 1,),
                    Text('바로 다른 사람들과 의견을 나눠보세요 !', 
                    style: TextStyle(fontSize: 17 ),),
                    ],
                  ),
              ],),
            ],
          ),
          const SizedBox(height: 50), // 간격 추가
          Expanded(
              child: GridView.count(
                crossAxisCount: 1, // 한 줄에 3개의 아이템을 표시
                childAspectRatio: 4/0.75,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10
                ),
                mainAxisSpacing: 10,
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
                        color: _selectedIndex == index ? const Color(0xFF8E48F8) : Colors.grey),
                        borderRadius:BorderRadius.circular(20)
                      ),
                      alignment: Alignment.center,
                      child: Text('Item $index'
                    ),
                  ),
                  );
                }),
              ),
            ),
            
          Padding(
            padding: const EdgeInsets.all(16.0),
          child : SizedBox(
            width: 500,
            height: 60,
            child: Row(
              
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E48F8),
                  fixedSize: Size(170,60),
                ),
                          child: const Text(
                  '토론', style: TextStyle (color:Colors.white,
                  fontSize: 18),),
                ),
                SizedBox(width: 13,),
                ElevatedButton(
                  onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor:  const Color(0xFF8E48F8),
                  fixedSize: Size(170,60),
                  ),
                          child: const Text(
                  '자게', style: TextStyle (color:Colors.white,
                  fontSize: 18),),
                ),
              ],
            ),
        ),
        ),
        const SizedBox(height: 23),
      ],
    ),
    );
  }
}
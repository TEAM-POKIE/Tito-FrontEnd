// import 'package:flutter/material.dart';

// class FreeScreenWrite extends StatefulWidget {
//   @override
//   _FreeScreenWriteState createState() => _FreeScreenWriteState();
// }

// class _FreeScreenWriteState extends State<FreeScreenWrite> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _contentController = TextEditingController();
//   bool _isVotingEnabled = false;
//   List<TextEditingController> _votingControllers = [];

//   void _addVotingOption() {
//     setState(() {
//       _votingControllers.add(TextEditingController());
//     });
//   }

//   void _removeVotingOption(int index) {
//     setState(() {
//       _votingControllers.removeAt(index);
//     });
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _contentController.dispose();
//     super.dispose();
//   }

//   void _submitPost() {
//     final String title = _titleController.text;
//     final String content = _contentController.text;
//     final bool isVotingEnabled = _isVotingEnabled;

//     // 여기에 게시글 제출 로직 추가
//     print('Title: $title');
//     print('Content: $content');
//     print('Voting Enabled: $isVotingEnabled');

//     // 게시글 제출 후 이전 화면으로 돌아가기
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back_ios),
//         ),
//         title: const Text(
//           '주제에 대한 내용과 투표 여부를 설정해보세요!',
//           style: TextStyle(
//             fontSize: 17,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('제목', style: TextStyle(fontSize: 16.0)),
//                     SizedBox(height: 8.0),
//                     TextField(
//                       controller: _titleController,
//                       decoration: InputDecoration(
//                         hintText: '입력하세요',
//                         filled: true,
//                         fillColor: const Color(0xFFF6F6F6),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20.0),
//                             borderSide: BorderSide.none),
//                       ),
//                     ),
//                     SizedBox(height: 50.0),
//                     Text('내용', style: TextStyle(fontSize: 16.0)),
//                     SizedBox(height: 8.0),
//                     TextField(
//                       controller: _contentController,
//                       decoration: InputDecoration(
//                           hintText: '입력하세요',
//                           filled: true,
//                           fillColor: const Color(0xFFF6F6F6),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(20.0),
//                               borderSide: BorderSide.none)),
//                       maxLines: 10,
//                     ),
//                     SizedBox(height: 50.0),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('투표', style: TextStyle(fontSize: 16.0)),
//                         Switch(
//                           value: _isVotingEnabled,
//                           onChanged: (bool value) {
//                             setState(() {
//                               _isVotingEnabled = value;
//                               if (!value) {
//                                 _votingControllers.clear();
//                               }
//                             });
//                           },
//                           activeColor: const Color(0xFF8E48F8), // 활성화 상태에서의 색상
//                           activeTrackColor: Color.fromARGB(
//                               255, 186, 146, 246), // 활성화 상태에서의 트랙 색상
//                           inactiveThumbColor: Colors.grey,
//                         ),
//                       ],
//                     ),
//                     if (_isVotingEnabled) ...[
//                       for (int i = 0; i < _votingControllers.length; i++)
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: TextField(
//                                   controller: _votingControllers[i],
//                                   decoration: InputDecoration(
//                                     hintText: '입력하세요',
//                                     filled: true,
//                                     fillColor: const Color(0xFFF6F6F6),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(20.0),
//                                       borderSide: BorderSide.none,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.remove_circle,
//                                     color: Colors.red),
//                                 onPressed: () => _removeVotingOption(i),
//                               ),
//                             ],
//                           ),
//                         ),
//                       SizedBox(height: 8.0),
//                       OutlinedButton(
//                         onPressed: _addVotingOption,
//                         child: Text('추가 +'),
//                         style: OutlinedButton.styleFrom(
//                           //primary: Colors.blue,
//                           side: BorderSide(color: Colors.blue),
//                         ),
//                       ),
//                     ],
//                     Spacer(),
//                     SizedBox(height: 20.0),
//                     ElevatedButton(
//                       onPressed: () {
//                         // 버튼 클릭 시 실행할 동작
//                       },
//                       style: ElevatedButton.styleFrom(
//                         // primary: Colors.blue,
//                         // onPrimary: Colors.white,
//                         shadowColor: Colors.blueAccent,
//                         elevation: 5,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20.0),
//                         ),
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 32.0, vertical: 16.0),
//                       ),
//                       child: Center(
//                           child: Text('게시글 작성하기',
//                               style: TextStyle(fontSize: 16.0))),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class FreeScreenWrite extends StatefulWidget {
  @override
  _FreeScreenWriteState createState() => _FreeScreenWriteState();
}

class _FreeScreenWriteState extends State<FreeScreenWrite> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isVotingEnabled = false;
  List<TextEditingController> _votingControllers = [];

  void _addVotingOption() {
    setState(() {
      _votingControllers.add(TextEditingController());
    });
  }

  void _removeVotingOption(int index) {
    setState(() {
      _votingControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '주제에 대한 내용과\n투표 여부를 설정해보세요!',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('제목', style: TextStyle(fontSize: 16.0)),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: '입력하세요',
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.lightBlue[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 20.0),
                    Text('내용', style: TextStyle(fontSize: 16.0)),
                    SizedBox(height: 8.0),
                    Container(
                      height: 200.0,
                      child: TextField(
                        controller: _contentController,
                        decoration: InputDecoration(
                          hintText: '입력하세요',
                          filled: true,
                          fillColor: const Color(0xFFF6F6F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        maxLines: null,
                        expands: true,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('투표', style: TextStyle(fontSize: 16.0)),
                        Transform.scale(
                          scale: 1.5,
                          child: Switch(
                            value: _isVotingEnabled,
                            onChanged: (bool value) {
                              setState(() {
                                _isVotingEnabled = value;
                                if (!value) {
                                  _votingControllers.clear();
                                }
                              });
                            },
                            activeColor: Colors.blue,
                            activeTrackColor: Colors.blue.shade100,
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                    if (_isVotingEnabled) ...[
                      for (int i = 0; i < _votingControllers.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _votingControllers[i],
                                  decoration: InputDecoration(
                                    hintText: '입력하세요',
                                    filled: true,
                                    fillColor: const Color(0xFFF6F6F6),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () => _removeVotingOption(i),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 8.0),
                      OutlinedButton(
                        onPressed: _addVotingOption,
                        child: Text('추가 +'),
                        style: OutlinedButton.styleFrom(
                          //primary: Colors.blue,
                          side: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // 버튼 클릭 시 실행할 동작
              },
              style: ElevatedButton.styleFrom(
                // primary: Colors.blue,
                // onPrimary: Colors.white,
                shadowColor: Colors.blueAccent,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              ),
              child: Center(child: Text('게시글 작성하기', style: TextStyle(fontSize: 16.0))),
            ),
          ),
        ],
      ),
    );
  }
}

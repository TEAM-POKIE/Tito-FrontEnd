// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;
// import 'package:tito_app/src/data/models/freescreen_info.dart';

// class FreeScreenWrite extends StatefulWidget {
//   @override
//   _FreeScreenWriteState createState() => _FreeScreenWriteState();
// }

// class _FreeScreenWriteState extends State<FreeScreenWrite> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _contentController = TextEditingController();
//   bool _isVotingEnabled = false;
//   List<TextEditingController> _votingControllers = [];
//   //객체들의 리스트 생성하는 것 -> 텍스트 필드를 한번에 관리하기 위해 사용

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

//   Future<void> _writePost() async {
//     String title = _titleController.text;
//     String content = _contentController.text;

//     if (title.isNotEmpty && content.isNotEmpty) {
//       final url = Uri.https(
//           'pokeeserver-default-rtdb.firebaseio.com', 'write-post.json');
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'title': title,
//           'content': content,
//           'timestamp': DateTime.now().toIso8601String(),
//         }),
//       );

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('게시글이 저장되었습니다!')),
//         );

//         final Map<String, dynamic> resData = json.decode(response.body);

//         if (!context.mounted) {
//           return;
//         }

//         Navigator.of(context).pop(
//           FreeScreenItem(
//             id: resData['name'],
//             title: title,
//             content: content,
//             timestamp: DateTime.now(),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('게시글 저장에 실패했습니다.')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('모든 필드를 입력하세요!')),
//       );
//     }
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
//       ),
//       body: Column(
//         children: [
//           const Text(
//             '주제에 대한 내용과 투표 여부를 설정해보세요!',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//             textAlign: TextAlign.left,
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 20.0),
//                     const Text('제목',
//                         style: TextStyle(
//                             fontSize: 16.0, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 10.0),
//                     TextField(
//                       controller: _titleController,
//                       decoration: const InputDecoration(
//                         hintText: '입력하세요',
//                         hintStyle: TextStyle(color: Colors.grey),
//                         filled: true,
//                         fillColor: Color(0xFFF6F6F6),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       style: const TextStyle(color: Colors.black),
//                     ),
//                     const SizedBox(height: 30.0),
//                     const Text('내용',
//                         style: TextStyle(
//                             fontSize: 16.0, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 10.0),
//                     Container(
//                       height: 230.0,
//                       child: TextField(
//                         controller: _contentController,
//                         decoration: InputDecoration(
//                           contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 10.0, vertical: 250.0),
//                           hintText: '입력하세요',
//                           hintStyle: const TextStyle(color: Colors.grey),
//                           filled: true,
//                           fillColor: const Color(0xFFF6F6F6),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(30.0),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 40.0),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text('투표',
//                             style: TextStyle(
//                                 fontSize: 16.0, fontWeight: FontWeight.bold)),
//                         Transform.scale(
//                           scale: 1,
//                           child: Switch(
//                             value: _isVotingEnabled,
//                             //_isVotingEnaled가 true이면, 스위치가 켜진 상태
//                             onChanged: (bool value) {
//                               setState(() {
//                                 _isVotingEnabled = value;
//                                 if (!value) {
//                                   _votingControllers.clear();
//                                   //리스트를 비움으로써 컨트롤러 초기화하는 것
//                                 }
//                               });
//                             },
//                             activeColor: const Color(0xFF8E48F8),
//                             activeTrackColor:
//                                 const Color.fromARGB(255, 215, 192, 248),
//                             inactiveThumbColor: Colors.grey,
//                             inactiveTrackColor: const Color(0xFFF6F6F6),
//                           ),
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
//                                     hintStyle:
//                                         const TextStyle(color: Colors.grey),
//                                     filled: true,
//                                     fillColor: const Color(0xFFF6F6F6),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(30.0),
//                                       borderSide: BorderSide.none,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.remove_circle,
//                                     color: Colors.grey),
//                                 onPressed: () => _removeVotingOption(i),
//                               ),
//                             ],
//                           ),
//                         ),
//                       const SizedBox(height: 8.0),
//                       Container(
//                         width: 380.0,
//                         height: 55.0,
//                         child: OutlinedButton(
//                           onPressed: _addVotingOption,
//                           child: Text(
//                             '추가  +',
//                             style: TextStyle(
//                               color: Color.fromARGB(255, 109, 109, 109),
//                             ),
//                           ),
//                           style: OutlinedButton.styleFrom(
//                             side: const BorderSide(color: Colors.grey),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             width: 370,
//             height: 60,
//             child: ElevatedButton(
//                 onPressed: _writePost,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF8E48F8),
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 ),
//                 child: const Text(
//                   '게시글 작성하기',
//                   style: TextStyle(fontSize: 18),
//                 )),
//           ),
//           const SizedBox(height: 23),
//         ],
//       ),
//     );
//   }
// }

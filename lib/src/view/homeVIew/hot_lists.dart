import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/core/provider/home_state_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/src/data/models/debate_hotdebate.dart';
import '../../../core/api/api_service.dart';

// Column(
//   children: List.generate(homeState.hotItems.length, (index) {
//     final hotItem = homeState.hotItems[index];
//     return Padding(
//       padding:
//           const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//       child: Container(
//         decoration: BoxDecoration(
//           color: ColorSystem.white,
//           borderRadius: BorderRadius.circular(20.r),
//         ),
//         child: ListTile(
//           leading: Image.asset(
//             'assets/images/hotlist.png', // Add your image path here
//             width: 40,
//             height: 40,
//           ),
//           title: Text(
//             '바보',
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//             maxLines: 1, // 텍스트를 한 줄로 제한
//             overflow: TextOverflow.ellipsis, // 넘칠 경우 "..." 처리
//           ),
//           subtitle: Text(
//             '멍청이',
//             maxLines: 1, // 텍스트를 한 줄로 제한
//             overflow: TextOverflow.ellipsis, // 넘칠 경우 "..." 처리
//           ),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(
//                 Icons.whatshot,
//                 color: ColorSystem.purple,
//               ),
//               const SizedBox(width: 5),
//               Text(
//                 hotItem.hotScore.toString(),
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: ColorSystem.grey,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }),
// ),
class HotLists extends ConsumerStatefulWidget {
  const HotLists({super.key});

  @override
  ConsumerState<HotLists> createState() {
    return _HotListState();
  }
}

class _HotListState extends ConsumerState<HotLists> {
  List<DebateHotdebate> hotlist = [];
  bool isLoading = true;

  // @override
  // void initState() {
  //   super.initState();
  //   fetchHotDebates(); // API 호출
  // }

  // Future<void> fetchHotDebates() async {
  //   try {
  //     final debateResponse =
  //         await ApiService(DioClient.dio).getDebateHotdebate();

  //     // 디버깅을 위해 API 응답을 출력
  //     print('API Response: $debateResponse');

  //     setState(() {
  //       hotlist = [debateResponse]; // response를 리스트로 감싸서 할당
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     print('Error fetching debates: $e');
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);
    final homeViewModel = ref.read(homeViewModelProvider.notifier);

    return Column(
      children: [
        SizedBox(height: 30.h),
        // Padding(
        //   padding: EdgeInsets.symmetric(
        //     horizontal: 20.h,
        //   ),
        //   child: Row(
        //     //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       const Text(
        //         'HOT한 토론',
        //         style: FontSystem.KR18SB,
        //       ),
        //       SizedBox(
        //         width: 6.w,
        //       ),
        //       Container(
        //           width: 39.5.w,
        //           height: 29.06.h,
        //           child: Image.asset('assets/images/hotlist.png')),
        //     ],
        //   ),
        // ),
        // Container(
        //   height: 150.h,
        //   child: isLoading
        //       ? Center(child: CircularProgressIndicator()) // 로딩 중일 때
        //       : hotlist.isEmpty
        //           ? Center(child: Text('No debates available')) // 데이터가 없을 때
        //           : ListView.builder(
        //               itemCount: hotlist.length,
        //               // hotlist의 길이로 설정
        //               itemBuilder: (context, index) {
        //                 return Container(
        //                   decoration: BoxDecoration(
        //                       border: Border.all(color: ColorSystem.red)),
        //                   child: ListTile(
        //                     title: Text(
        //                         hotlist[index].debateTitle), // 각 항목의 제목을 표시
        //                     subtitle: Text(hotlist[index]
        //                         .debateMakerOpinion), // 필요에 따라 다른 속성도 표시 가능
        //                   ),
        //                 );
        //               },
        //             ),
        // ),
      ],
    );
  }
}

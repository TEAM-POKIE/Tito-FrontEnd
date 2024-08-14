import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/screen/home_screen.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

// class MyAlarmScrollbody extends StatefulWidget {
//   @override
//   _MyAlarmScrollBodyState createState() => _MyAlarmScrollBodyState();
// }

// class _MyAlarmScrollBodyState extends State<MyAlarmScrollbody> {
//   final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
//   final GlobalKey<AnimatedListState> _secondListKey =
//       GlobalKey<AnimatedListState>();
//   final List<String> _alarms = List.generate(15, (index) => '새로운 알림예시 $index');
//   final List<String> _oldAlarms =
//       List.generate(15, (index) => '지난 알림예시 $index');

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           height: 20.h,
//         ),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: const Text(
//             '새로운 알림',
//             style: FontSystem.KR20B,
//           ),
//         ),
//         SizedBox(height: 15.h),
//         Container(
//           height: 460.h,
//           child: Expanded(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 3.w),
//               child: AnimatedList(
//                 key: _listKey,
//                 initialItemCount: _alarms.length,
//                 itemBuilder: (context, index, animation) {
//                   return _buildItem(context, _alarms[index], animation, index);
//                 },
//               ),
//             ),
//           ),
//         ),
//         SizedBox(height: 40.h),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: const Text(
//             '지난 알림',
//             style: FontSystem.KR20B,
//           ),
//         ),
//         SizedBox(
//           height: 15.h,
//         ),
//         Expanded(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 3.w),
//             child: AnimatedList(
//               key: _secondListKey,
//               initialItemCount: _oldAlarms.length,
//               itemBuilder: (context, index, animation) {
//                 return _buildSecondItem(
//                     context, _oldAlarms[index], animation, index);
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// Widget _buildItem(
//     BuildContext context, String user, Animation<double> animation, int index) {
//   return SizeTransition(
//     sizeFactor: animation,
//     child: Padding(
//       padding: EdgeInsets.symmetric(vertical: 4.h),
//       child: ListTile(
//         onTap: () {},
//         leading: SvgPicture.asset('assets/icons/alarm_new.svg'),
//         title: Text(
//           user,
//           style: FontSystem.KR16B.copyWith(color: ColorSystem.purple),
//         ),
//         subtitle: Text(
//           '지금',
//           style: FontSystem.KR14R.copyWith(color: ColorSystem.grey),
//         ),
//       ),
//     ),
//   );
// }

// Widget _buildSecondItem(
//     BuildContext context, String user, Animation<double> animation, int index) {
//   return SizeTransition(
//     sizeFactor: animation,
//     child: Padding(
//       padding: EdgeInsets.symmetric(vertical: 4.h),
//       child: ListTile(
//         leading: SvgPicture.asset('assets/icons/alarm.svg'),
//         title: Text(
//           user,
//           style: FontSystem.KR16B,
//           maxLines: 1, // 텍스트를 한 줄로 제한
//           overflow: TextOverflow.ellipsis, // 넘칠 경우 "..." 처리
//         ),
//         subtitle: Text(
//           '지난 8시간',
//           style: FontSystem.KR14R.copyWith(color: ColorSystem.grey),
//         ),
//       ),
//     ),
//   );
// }

class MyAlarmScrollBody extends StatefulWidget {
  @override
  _MyAlarmScrollBodyState createState() => _MyAlarmScrollBodyState();
}

class _MyAlarmScrollBodyState extends State<MyAlarmScrollBody> {
  final List<String> _alarms = List.generate(15, (index) => '새로운 알림예시 $index');
  final List<String> _oldAlarms =
      List.generate(15, (index) => '지난 알림예시 $index');

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 11.w),
      itemCount: _alarms.length + _oldAlarms.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          // '새로운 알림' 제목
          return Padding(
            padding: EdgeInsets.only(bottom: 15.h, left: 10.w),
            child: const Text(
              '새로운 알림',
              style: FontSystem.KR20B,
            ),
          );
        } else if (index <= _alarms.length) {
          // 새로운 알림 항목들
          return _buildItem(context, _alarms[index - 1], index - 1);
        } else if (index == _alarms.length + 1) {
          // '지난 알림' 제목
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h),
            child: const Text(
              '지난 알림',
              style: FontSystem.KR20B,
            ),
          );
        } else {
          // 지난 알림 항목들
          return _buildSecondItem(
              context,
              _oldAlarms[index - _alarms.length - 2],
              index - _alarms.length - 2);
        }
      },
    );
  }

  Widget _buildItem(BuildContext context, String user, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: ListTile(
        onTap: () {},
        leading: SvgPicture.asset('assets/icons/alarm_new.svg'),
        title: Text(
          user,
          style: FontSystem.KR16B.copyWith(color: ColorSystem.purple),
        ),
        subtitle: Text(
          '지금',
          style: FontSystem.KR14R.copyWith(color: ColorSystem.grey),
        ),
      ),
    );
  }

  Widget _buildSecondItem(BuildContext context, String user, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: ListTile(
        leading: SvgPicture.asset('assets/icons/alarm.svg'),
        title: Text(
          user,
          style: FontSystem.KR16B,
          maxLines: 1, // 텍스트를 한 줄로 제한
          overflow: TextOverflow.ellipsis, // 넘칠 경우 "..." 처리
        ),
        subtitle: Text(
          '지난 8시간',
          style: FontSystem.KR14R.copyWith(color: ColorSystem.grey),
        ),
      ),
    );
  }
}

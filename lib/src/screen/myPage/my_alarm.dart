import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:tito_app/src/view/myPage/my_alarm_appbar.dart';
import 'package:tito_app/src/view/myPage/my_alarm_scrollbody.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAlarm extends ConsumerWidget {
  const MyAlarm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.h),
          child: const MyAlarmAppbar(),
        ),
        body: MyAlarmScrollBody(),
      ),
    );
  }
}

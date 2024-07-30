import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/screen/home_screen.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/src/view/chatView/profile_popup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class MyBlockScrollbody extends ConsumerWidget {
  const MyBlockScrollbody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '차단한 유저',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    width: 530.w,
                    //height: ,
                    child: ProfilePopup(),
                    ),
                );
              },
            );
          },
          child: Text("Show Profile Popup"),
        ),
      ],
    );
  }
}

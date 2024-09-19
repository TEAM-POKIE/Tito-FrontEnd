import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Debateinfopopup extends ConsumerStatefulWidget {
  const Debateinfopopup({super.key});

  @override
  ConsumerState<Debateinfopopup> createState() {
    return _DebateinfoState();
  }
}

class _DebateinfoState extends ConsumerState<Debateinfopopup> {
  @override
  Widget build(BuildContext context) {
    final chatState = ref.read(chatInfoProvider);

    return Dialog(
      backgroundColor: ColorSystem.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        width: 350.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      chatState!.debateTitle,
                      style: FontSystem.KR16SB,
                      //overflow: TextOverflow.ellipsis,
                      //maxLines: 2,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: const Divider(
                color: ColorSystem.grey3,
                thickness: 1,
              ),
            ),
            _buildProfileHeader(ref),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: chatState.debateImageUrl == ''
                  ? SvgPicture.asset(
                      'assets/icons/list_real_null.svg',
                      fit: BoxFit.contain,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12.r), // 둥근 모서리 설정
                      child: Image.network(
                        chatState.debateImageUrl,
                        width: 260.w, // 원하는 너비 설정
                        height: 250.h,
                        fit: BoxFit.cover, // 이미지가 잘리지 않도록 맞춤 설정
                      ),
                    ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(WidgetRef ref) {
    final chatState = ref.read(chatInfoProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset('assets/icons/popup_face.svg'),
              SizedBox(width: 5.w),
              Expanded(
                child: Text(chatState!.debateContent, style: FontSystem.KR14SB),
              ),
            ],
          ),
          // Row(
        ),
      ],
    );
  }
}

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:tito_app/core/api/multpart_file_with_to_json.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/src/view/myPage/exit_popup.dart';
import 'package:tito_app/src/view/myPage/logout_popup.dart';


import 'package:tito_app/src/widgets/reuse/profile_popup.dart';

class MypageMain extends ConsumerStatefulWidget {
  const MypageMain({super.key});

  @override
  ConsumerState<MypageMain> createState() => _MypageMainState();
}

class _MypageMainState extends ConsumerState<MypageMain> {
  XFile? _image;
  final ImagePicker picker = ImagePicker();

  Future<void> requestPermissions() async {
    await [Permission.camera, Permission.photos].request();
  }

  Future<void> getImage(ImageSource source) async {
    await requestPermissions();
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
      // 이미지 업로드 및 프로필 업데이트
      String? imageUrl = await uploadImage(File(_image!.path));
      if (imageUrl != null) {
        await updateUserProfile(imageUrl);
        // 프로필 정보 다시 불러오기
        ref.refresh(loginInfoProvider);
      }
    }
  }

  Future<String?> uploadImage(File imageFile) async {
    // final dio = Dio();
    // final apiService = ApiService(dio);
    // try {
    //   FormData formData = FormData.fromMap({
    //     "file": await MultipartFile.fromFile(imageFile.path,
    //         filename: "upload.jpg"),
    //   });
    //   final response = await apiService.uploadImage(MultipartFileWithToJson(
    //     await MultipartFile.fromFile(imageFile.path, filename: "upload.jpg"),
    //   ));
    //   return response['fileUrl'];
    // } catch (e) {
    //   print(e);
    //   return null;
    // }
  }

  Future<void> updateUserProfile(String profileImageUrl) async {
    final dio = Dio();
    final apiService = ApiService(dio);
    final loginInfo = ref.read(loginInfoProvider);
    try {
      await apiService.updateUserProfile(loginInfo!.id, {
        "profilePicture": profileImageUrl,
      });

      // // 로그인 정보를 상태로 업데이트
      // ref.read(loginInfoProvider.notifier).state = loginInfo.copyWith(
      //   profilePicture: profileImageUrl,
      // );
    } catch (e) {
      print(e);
    }
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('갤러리'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('카메라'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('회원탈퇴'),
          content: const Text('정말로 회원탈퇴를 하시겠습니까? 이 작업은 되돌릴 수 없습니다.'),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('탈퇴'),
              onPressed: () {
                // Perform the account deletion operation here
                Navigator.of(context).pop();
                // Optionally, navigate to another screen after deletion
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginInfo = ref.watch(loginInfoProvider);
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 22.h),
              Stack(
                children: [
                  SvgPicture.asset(
                    'assets/icons/circle_profile.svg',
                    width: 70,
                    height: 70,
                    color: ColorSystem.lightPurple,
                  ),
                  // CircleAvatar(
                  //   radius: 35.r,
                  //   backgroundImage: _image != null
                  //       ? FileImage(File(_image!.path)) as ImageProvider
                  //       : loginInfo?.profilePicture == null
                  //           ? null
                  //           : NetworkImage(loginInfo!.profilePicture!)
                  //               as ImageProvider,
                  //   child: _image == null && loginInfo?.profilePicture == null
                  //       ? SvgPicture.asset(
                  //           'assets/icons/circle_profile.svg',
                  //           fit: BoxFit.cover,
                  //         )
                  //       : null,
                  // ),
                  Positioned(
                    bottom: -10,
                    right: -10,
                    child: Transform.rotate(
                      angle: 0.1,
                      child: IconButton(
                        iconSize: 30.0,
                        onPressed: () {
                          _showImagePickerOptions(context);
                        },
                        icon: SvgPicture.asset('assets/icons/mypage_edit.svg'),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${loginInfo?.nickname}',
                    style: FontSystem.KR24B.copyWith(color: ColorSystem.purple),
                  ),
                  IconButton(
                    onPressed: () {
                      context.go('/nickname');
                    },
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),

              Container(
                width: 90.w,
                height: 33.h,
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
                decoration: BoxDecoration(
                  color: ColorSystem.lightPurple,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: ColorSystem.purple),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '승률 80%',
                    style: FontSystem.KR18B.copyWith(color: ColorSystem.purple),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              const Text(
                '12전 | 10승 | 2패',
                style: FontSystem.KR18R,
              ),
              SizedBox(height: 34.h),
              // Divider(thickness: 4),
              Container(
                width: double.infinity,
                height: 4.h,
                margin: EdgeInsets.symmetric(vertical: 20.h),
                decoration: BoxDecoration(
                  color: ColorSystem.grey3,
                  borderRadius: BorderRadius.circular(4.h),
                ),
              ),
              SizedBox(height: 10.h),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '내 활동',
                  style: FontSystem.KR14B,
                ),
              ),
              SizedBox(height: 20.h),
              _buildListTile(
                context,
                title: '내가 참여한 토론',
                onTap: () => context.go('/mydebate'),
              ),
              _buildListTile(
                context,
                title: '알림',
                onTap: () => context.go('/myalarm'),
              ),
              _buildListTile(
                context,
                title: '차단 리스트',
                onTap: () => context.go('/myblock'),
              ),
              SizedBox(height: 46.h),
              Container(
                width: double.infinity,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 10.h),
                decoration: BoxDecoration(
                  color: ColorSystem.grey3,
                  borderRadius: BorderRadius.circular(4.h),
                ),
              ),
              SizedBox(height: 20.h),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '설정',
                  style: FontSystem.KR14B,
                ),
              ),

              SizedBox(height: 20.h),
              _buildListTile(
                context,
                title: '비밀번호 변경',
                onTap: () => context.go('/password'),
              ),
              _buildListTile(
                context,
                title: '문의하기',
                onTap: () => context.go('/contact'),
              ),
              _buildListTile(
                context,
                title: '개인정보처리방침',
                onTap: () => context.go('/personalRule'),
              ),
              _buildListTile(
                context,
                title: '이용약관',
                onTap: () => context.go('/rule'),
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ProfilePopup();
                        },
                      );
                    },
                    child: const Text(
                      '로그아웃',
                      style: TextStyle(color: ColorSystem.grey),
                    ),
                  ),
                  const Text(
                    '|',
                    style: TextStyle(color: ColorSystem.grey),
                  ),
                  TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ExitPopup();
                          },
                        );
                      },
                      child: const Text(
                        '회원탈퇴',
                        style: TextStyle(color: ColorSystem.grey),
                      )),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required String title, required VoidCallback onTap}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 11.h),
      child: Container(
        height: 60.h,
        width: 350.w,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0x669795A3),
              spreadRadius: 0,
              blurRadius: 4,
            )
          ],
          //border: Border.all(color: ColorSystem.grey),
          borderRadius: BorderRadius.circular(20.r),
          color: ColorSystem.white,
        ),
        child: ListTile(
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: onTap,
        ),
      ),
    );
  }
}

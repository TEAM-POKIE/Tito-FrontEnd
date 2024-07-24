import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:tito_app/core/api/multpart_file_with_to_json.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:tito_app/core/api/api_service.dart';

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
    final dio = Dio();
    final apiService = ApiService(dio);
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imageFile.path,
            filename: "upload.jpg"),
      });
      final response = await apiService.uploadImage(MultipartFileWithToJson(
        await MultipartFile.fromFile(imageFile.path, filename: "upload.jpg"),
      ));
      return response['fileUrl'];
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> updateUserProfile(String profileImageUrl) async {
    final dio = Dio();
    final apiService = ApiService(dio);
    final loginInfo = ref.read(loginInfoProvider);
    try {
      await apiService.updateUserProfile(loginInfo!.id, {
        "profilePicture": profileImageUrl,
      });

      // 로그인 정보를 상태로 업데이트
      ref.read(loginInfoProvider.notifier).state = loginInfo.copyWith(
        profilePicture: profileImageUrl,
      );
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
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: _image != null
                      ? FileImage(File(_image!.path)) as ImageProvider
                      : loginInfo?.profilePicture == null
                          ? const AssetImage('assets/images/chatprofile.png')
                          : NetworkImage(loginInfo!.profilePicture!)
                              as ImageProvider,
                ),
                Positioned(
                  bottom: -5,
                  right: -5,
                  child: Transform.rotate(
                    angle: 0.1,
                    child: IconButton(
                      iconSize: 30.0,
                      onPressed: () {
                        _showImagePickerOptions(context);
                      },
                      icon: Image.asset('assets/images/changeprofile.png'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${loginInfo?.nickname}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 199, 255),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '승률 80%',
                style: TextStyle(
                    color: Color(0xFF8E48F8), fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '12전 | 10승 | 2패',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 2),
            const SizedBox(height: 15.0),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '내 활동',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            _buildListTile(
              context,
              title: '내가 참여한 토론',
              onTap: () => context.go('/mydebate'),
            ),
            _buildListTile(
              context,
              title: '내가 쓴 게시글',
              onTap: () => context.go('/mylist'),
            ),
            _buildListTile(
              context,
              title: '좋아요',
              onTap: () => context.go('/mylike'),
            ),
            _buildListTile(
              context,
              title: '알림',
              onTap: () => context.go('/myalarm'),
            ),
            const SizedBox(height: 10.0),
            const Divider(thickness: 2),
            const SizedBox(height: 15.0),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '설정',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            _buildListTile(
              context,
              title: '비밀번호 수정',
              onTap: () => context.go('/password'),
            ),
            _buildListTile(
              context,
              title: '문의하기',
              onTap: () => context.go('/contact'),
            ),
            _buildListTile(
              context,
              title: '로그아웃',
              onTap: () {},
            ),
            _buildListTile(
              context,
              title: '회원탈퇴',
              onTap: () => showExitDialog(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
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

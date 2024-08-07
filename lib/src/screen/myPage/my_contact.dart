import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'dart:io';
import 'package:tito_app/src/view/myPage/pick_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyContact extends StatefulWidget {
  const MyContact({super.key});

  @override
  _MyContactState createState() => _MyContactState();
}

class _MyContactState extends State<MyContact> {
  File? _imageFile;
  final PickImage _pickImageService = PickImage();

  Future<void> _pickImage() async {
    final pickedImage = await _pickImageService.pickImageFromGallery();

    setState(() {
      _imageFile = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSystem.white,
        leading: IconButton(
          onPressed: () {
            context.go('/mypage');
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          '문의하기',
          style: FontSystem.KR16SB,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 51.h),
              const Text('내용', style: FontSystem.KR16SB),
              SizedBox(height: 10.h),
              Container(
                height: 200.h,
                child: TextField(
                  //controller: _contentController,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 250.h),
                    // hintText: '입력하세요',
                    // hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: ColorSystem.ligthGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
             Row(
                    children: [
                      Container(
                        width: 115.w,
                        height: 45.h,
                        child: TextButton.icon(
                          onPressed: () {}, //debateViewModel.pickImage,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: ColorSystem.white,
                          ),
                          label: Text(
                            '파일 첨부',
                            style: FontSystem.KR14M
                                .copyWith(color: ColorSystem.white),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: ColorSystem.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              SizedBox(height: 20.h),
              const Text('연락받을 이메일', style: FontSystem.KR16SB),
              SizedBox(height: 10.h),
              TextField(
                //controller: _titleController,
                decoration: InputDecoration(
                  // hintText: '입력하세요',
                  // hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: ColorSystem.ligthGrey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: ColorSystem.black),
              ),
              SizedBox(height: 20.h),
              const Text('이용자 아이디', style: FontSystem.KR16SB),
              SizedBox(height: 10.h),
              TextField(
                //controller: _titleController,
                decoration: InputDecoration(
                  // hintText: '입력하세요',
                  // hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: ColorSystem.ligthGrey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: ColorSystem.black),
              ),
              SizedBox(height: 20.h),
              const Text('학교', style: FontSystem.KR16SB),
              TextField(
                //controller: _titleController,
                decoration: InputDecoration(
                  // hintText: '입력하세요',
                  // hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: ColorSystem.ligthGrey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: ColorSystem.black),
              ),
              SizedBox(height: 28.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 47.h),
        child: SizedBox(
          width: 350.w,
          height: 60.h,
          child: ElevatedButton(
            onPressed: () {
              context.go('/mypage');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorSystem.purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Text(
              '문의 접수',
              style: TextStyle(fontSize: 20.sp, color: ColorSystem.white),
            ),
          ),
        ),
      ),
    );
  }
}

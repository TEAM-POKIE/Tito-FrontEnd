import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PickImage {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}


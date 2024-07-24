import 'package:dio/dio.dart';

class MultipartFileWithToJson {
  final MultipartFile file;

  MultipartFileWithToJson(this.file);

  Map<String, dynamic> toJson() {
    return {
      'filename': file.filename,
      'length': file.length,
      'contentType': file.contentType.toString(),
    };
  }
}

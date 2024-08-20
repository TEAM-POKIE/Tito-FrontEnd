import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';

class SelectionController extends GetxController {
  var selectedItems = <int>[].obs;

  void toggleSelection(int index) {
    if (selectedItems.contains(index)) {
      selectedItems.remove(index);
    } else {
      selectedItems.add(index);
    }
  }

  void resetSelection() async {
    final response = await ApiService(DioClient.dio).postGenerateTopic({
      "words": ["친구"]
    });
    print(response);
    selectedItems.clear();
  }
}

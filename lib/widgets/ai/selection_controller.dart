import 'package:get/get.dart';

class SelectionController extends GetxController {
  var selectedItems = <int>[].obs;

  void toggleSelection(int index) {
    if (selectedItems.contains(index)) {
      selectedItems.remove(index);
    } else {
      selectedItems.add(index);
    }
  }

  void resetSelection() {
    selectedItems.clear();
  }
}
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedIndexProvider =
    StateNotifierProvider<SelectedIndexNotifier, int>((ref) {
  return SelectedIndexNotifier();
});

class SelectedIndexNotifier extends StateNotifier<int> {
  SelectedIndexNotifier() : super(0);

  void setIndex(int index) {
    state = index;
  }
}

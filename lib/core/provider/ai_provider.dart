import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tito_app/src/widgets/ai/selection_controller.dart';

final selectionProvider =
    StateNotifierProvider<SelectionNotifier, SelectionState>((ref) {
  return SelectionNotifier();
});

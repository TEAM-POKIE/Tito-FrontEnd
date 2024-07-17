import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/viewModel/popup_viewModel.dart';

final popupProvider = StateNotifierProvider<PopupViewmodel, PopupState>(
  (ref) => PopupViewmodel(ref),
);

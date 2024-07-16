import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/viewModel/home_viewModel.dart';

final homeViewModelProvider = StateNotifierProvider<HomeViewmodel, HomeState>(
  (ref) => HomeViewmodel(),
);

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/data/models/debate_crate.dart';

import 'package:tito_app/src/viewModel/debate_create_viewModel.dart';

final debateCreateProvider =
    StateNotifierProvider<DebateCreateViewModel, DebateCreateState>(
        (ref) => DebateCreateViewModel());

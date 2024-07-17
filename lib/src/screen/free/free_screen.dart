import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/data/models/freescreen_info.dart';
import 'package:tito_app/src/view/freeView/free_appbar.dart';
import 'package:tito_app/src/view/freeView/free_view.dart';
import 'package:tito_app/src/widgets/free/free_screen_detail.dart';
import 'package:tito_app/src/widgets/free/free_screen_write.dart';
import 'package:tito_app/src/widgets/free/like_button.dart';
import 'package:tito_app/src/widgets/reuse/search_bar.dart';
import 'package:tito_app/src/widgets/reuse/bottombar.dart';
import 'package:tito_app/core/provider/app_state.dart';
import 'package:tito_app/src/widgets/free/comment_button.dart';
import 'package:go_router/go_router.dart';

class FreeScreen extends ConsumerWidget {
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: FreeAppbar(),
      ),
      body: Stack(children: [FreeView()]),
    );
  }
}

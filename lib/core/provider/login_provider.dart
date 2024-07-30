import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/data/models/login_info.dart';

class LoginInfoNotifier extends StateNotifier<LoginInfo?> {
  LoginInfoNotifier() : super(null);

  void setLoginInfo(LoginInfo loginInfo) {
    state = loginInfo;
  }

  void clearLoginInfo() {
    state = null;
  }
}

final loginInfoProvider = StateNotifierProvider<LoginInfoNotifier, LoginInfo?>(
  (ref) => LoginInfoNotifier(),
);

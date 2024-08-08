import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/data/models/user_profile.dart';

class UserprofileNotifier extends StateNotifier<UserProfile?> {
  UserprofileNotifier() : super(null);

  void setUserInfo(UserProfile userProfile) {
    state = userProfile;
  }

  void clearUserInfo() {
    state = null;
  }
}

final userProfileProvider =
    StateNotifierProvider<UserprofileNotifier, UserProfile?>(
  (ref) => UserprofileNotifier(),
);

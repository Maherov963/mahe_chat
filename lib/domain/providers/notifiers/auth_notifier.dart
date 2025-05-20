import 'package:mahe_chat/domain/models/user/user.dart';
import 'package:flutter/material.dart';

class AuthNotifier extends ChangeNotifier {
  Profile? _myUser;
  Profile? get myUser => _myUser;
  // bool _isLoading = false;
  // bool get isLoading => _isLoading;
  // final user1 = const Profile(
  //   id: 1,
  //   firstName: "Maherov",
  //   lastName: "Ghieh",
  //   phone: "+963 937 915 453",
  // );
  // final user2 = const Profile(
  //   id: 2,
  //   firstName: "sherlock",
  //   lastName: "holmes",
  //   phone: "+963 941 536 273",
  // );

  setUser2() {
    // _myUser = user2;
    notifyListeners();
  }

  void getStoredAccount() {
    // _myUser = user1;
    notifyListeners();
  }

  void login() {}
  void register() {}
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahe_chat/core/utils/states_handler.dart';
import 'package:mahe_chat/domain/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:mahe_chat/features/auth/domain/repo/auth_repo.dart';

final authProvider = ChangeNotifierProvider((ref) => AuthNotifier());

class AuthNotifier extends ChangeNotifier with StatesHandler {
  final AuthRepo _authRepo = AuthRepImpl();
  Profile? _myUser;
  Profile? get myUser => _myUser;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void getStoredAccount() {
    notifyListeners();
  }

  Future<ProviderStates> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    final res = await _authRepo.login(username, password);
    final state = failureOrDataToState(res);
    if (state is DataState<User>) {
      _myUser = Profile.fromUser(state.data);
    }
    _isLoading = false;
    notifyListeners();
    return state;
  }

  Future<ProviderStates> loginGoogle() async {
    _isLoading = true;
    notifyListeners();
    final res = await _authRepo.signInWithGoogle();
    final state = failureOrDataToState(res);
    if (state is DataState<User>) {
      _myUser = Profile.fromUser(state.data);
    }
    _isLoading = false;
    notifyListeners();
    return state;
  }

  Future<ProviderStates> getCashedUser() async {
    _isLoading = true;
    notifyListeners();
    final res = await _authRepo.getCashedUser();
    final state = failureOrDataToState(res);
    if (state is DataState<User?>) {
      if (state.data == null) {
        _myUser = null;
      } else {
        _myUser = Profile.fromUser(state.data!);
      }
    }
    _isLoading = false;
    notifyListeners();
    return state;
  }

  Future<ProviderStates> signOut() async {
    _isLoading = true;
    notifyListeners();
    final res = await _authRepo.signOut();
    final state = failureOrDataToState(res);
    _myUser = null;
    _isLoading = false;
    notifyListeners();
    return state;
  }
}

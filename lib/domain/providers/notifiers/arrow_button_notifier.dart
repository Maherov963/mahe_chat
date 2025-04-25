import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArrowButtonProvider extends StateNotifier<bool> {
  ArrowButtonProvider() : super(false);
  void setState(bool stat) {
    if (state != stat) {
      state = stat;
    }
  }
}

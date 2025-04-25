import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatSelectProvider extends StateNotifier<List<int>> {
  ChatSelectProvider() : super([]);
  void add(int index) {
    state = [...state, index];
  }

  void delete(int index) {
    state.remove(index);
    state = [...state];
  }

  void toggle(int index) {
    if (state.contains(index)) {
      delete(index);
    } else {
      add(index);
    }
  }

  void removeAll() {
    state = [];
  }
}

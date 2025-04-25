import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageSelectProvider extends StateNotifier<List<int>> {
  MessageSelectProvider() : super([]);
  void add(int index) {
    state = [...state, index];
  }

  void toggle(int index) {
    if (state.contains(index)) {
      delete(index);
    } else {
      add(index);
    }
  }

  void delete(int index) {
    state.remove(index);
    state = [...state];
  }

  void removeAll() {
    state = [];
  }
}

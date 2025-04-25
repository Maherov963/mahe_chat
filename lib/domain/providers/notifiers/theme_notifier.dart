import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ThemeState {
  dark,
  light,
  system,
}

class ThemeProvider extends StateNotifier<ThemeState> {
  ThemeProvider() : super(ThemeState.dark);
  void setTheme(ThemeState themeState) {
    state = themeState;
  }

  void getTheme() {
    state = ThemeState.dark;
  }
}

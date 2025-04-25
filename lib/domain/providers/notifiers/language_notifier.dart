import 'package:flutter_riverpod/flutter_riverpod.dart';

enum LanguageState {
  ar,
  en,
  fr,
}

class LanguageProvider extends StateNotifier<LanguageState> {
  LanguageProvider() : super(LanguageState.en);
  void setLanguage(LanguageState languageState) {
    state = languageState;
  }

  void getLanguage() {
    state = LanguageState.ar;
  }
}

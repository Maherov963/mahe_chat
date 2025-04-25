import 'package:mahe_chat/app/components/chat_input/mic_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MicProvider extends StateNotifier<MicController> {
  MicProvider() : super(MicController());
  void change({Offset? offset, bool? isMicPressed}) {
    state = MicController(
      offset: offset ?? state.offset,
      isMicPressed: isMicPressed ?? state.isMicPressed,
    );
  }

  void reset() {
    state = MicController(
      offset: Offset.zero,
      isMicPressed: false,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahe_chat/features/chat/presentation/components/chat_input/mic_button.dart';

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

import 'package:mahe_chat/app/components/chat_input/mic_button.dart';
import 'package:mahe_chat/domain/providers/notifiers/arrow_button_notifier.dart';
import 'package:mahe_chat/domain/providers/notifiers/auth_notifier.dart';
import 'package:mahe_chat/domain/providers/notifiers/chat_provider.dart';
import 'package:mahe_chat/domain/providers/notifiers/chat_select_notifier.dart';
import 'package:mahe_chat/domain/providers/notifiers/language_notifier.dart';
import 'package:mahe_chat/domain/providers/notifiers/message_select_notifier.dart';
import 'package:mahe_chat/domain/providers/notifiers/mic_notifier.dart';
import 'package:mahe_chat/domain/providers/notifiers/room_notifieer.dart';
import 'package:mahe_chat/domain/providers/notifiers/sound_notifier.dart';
import 'package:mahe_chat/domain/providers/notifiers/theme_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final networkProvider = StateNotifierProvider<NetworkInfoImpl, bool>(
//     (ref) => NetworkInfoImpl()..startStream());
final arrowButtonProvider = StateNotifierProvider<ArrowButtonProvider, bool>(
    (ref) => ArrowButtonProvider());
final languageProvider = StateNotifierProvider<LanguageProvider, LanguageState>(
    (ref) => LanguageProvider());
final themeProvider = StateNotifierProvider((ref) => ThemeProvider());
final chatProvider =
    ChangeNotifierProvider((ref) => ChatProvider()..initSounds());
final soundProvider = ChangeNotifierProvider((ref) => SoundNotifier());
final authProvider =
    ChangeNotifierProvider((ref) => AuthNotifier()..getStoredAccount());
final roomProvider = ChangeNotifierProvider((ref) => RoomProvider());
final chatSelectProvider = StateNotifierProvider<ChatSelectProvider, List<int>>(
    (ref) => ChatSelectProvider());
final messageSelectProvider =
    StateNotifierProvider<MessageSelectProvider, List<int>>(
        (ref) => MessageSelectProvider());
final micProvicer =
    StateNotifierProvider<MicProvider, MicController>((ref) => MicProvider());

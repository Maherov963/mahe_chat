// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'package:mahe_chat/data/datasources/local_db/message_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/messages/message.dart';
// import 'package:socket_io_client/socket_io_client.dart' as soio;
// import 'package:soundpool/soundpool.dart';

class ChatProvider extends ChangeNotifier {
  List<Message> _messages = [];
  final String _feedback = "";
  String get feedback => _feedback;
  final MessageDb _messageDb = MessageDb.instance;
  List<Message> get messages => _messages;
  // final soio.Socket socket = soio.io('http://192.168.1.7:4000', {
  //   "transports": ["websocket"],
  //   "autoConnect": false,
  // });

  int get nextId {
    return 0;
  }

  // Soundpool pool = Soundpool.fromOptions(
  //   options: const SoundpoolOptions(
  //     streamType: StreamType.music,
  //   ),
  // );

  int? sendSoundId;
  int? reciveSoundId;
  initSounds() async {
    reciveSoundId = await rootBundle
        .load("assets/audios/recive.wav")
        .then((ByteData soundData) {
      // return pool.load(soundData);
    });
    sendSoundId = await rootBundle
        .load("assets/audios/send.mp3")
        .then((ByteData soundData) {
      // return pool.load(soundData);
    });
  }

  Future getChat(int roomId) async {
    _messages = await _messageDb.getMessagesInRoom(roomId);
    notifyListeners();
  }

  addMessage(
    Message message,
    SendRecive sendRecive,
  ) async {
    if (sendRecive == SendRecive.recive) {
      if (Platform.isAndroid) {
        // pool.play(reciveSoundId!);
      }
    } else {
      if (Platform.isAndroid) {
        // pool.play(sendSoundId!);
      }
      // emitMessage(message);
    }
    // for (var i = 0; i < 500; i++) {
    _messageDb.addMessage(message);
    _messages.add(message);

    //   message = message.copyWith(id: nextId);
    // }
    // _messageDb.addMessage(message);
    notifyListeners();
  }

  //
  deleteMessage(List<int> indexes) async {
    for (var e in indexes) {
      _messages.removeWhere((element) {
        if (e == element.id) {
          _messageDb.deleteMessageById(element);
          return true;
        }
        return false;
      });
    }
    notifyListeners();
  }

  deleteAllMessage(int roomId) async {
    _messages = [];
    _messageDb.clearInRoom(roomId);
    notifyListeners();
  }
}

enum SendRecive {
  send,
  recive,
}

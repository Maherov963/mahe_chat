import 'dart:async';
import 'dart:io';
import 'package:mahe_chat/data/extensions/extension.dart';
import 'package:flutter_sound/flutter_sound.dart';
// ignore: depend_on_referenced_packages
import 'package:logger/logger.dart' show Level;
import 'package:path_provider/path_provider.dart';

class RecorderHolder {
  RecorderHolder._();
  static final RecorderHolder _instance = RecorderHolder._();
  static RecorderHolder get instance => _instance;
  final recorder = FlutterSoundRecorder(
    logLevel: Level.off,
  );
  bool isOpened = false;
  String? filePath;
  Timer? timer;
  Future record(int id, {void Function(int, String)? listner}) async {
    if (!recorder.isRecording && !isOpened) {
      timer?.cancel();
      isOpened = true;
      await recorder.openRecorder();
      final mainpath = await getApplicationDocumentsDirectory();
      Directory recordsdirectory = Directory("${mainpath.path}/records");
      await recordsdirectory.create();
      await recorder.startRecorder(
        bitRate: 46000,
        // sampleRate: 86000,
        numChannels: 2,
        toFile:
            '${mainpath.path}/records/voice$id-${DateTime.now().getYYYYMMDD()}.aac',
      );
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!isOpened) {
          timer.cancel();
        }
        listner?.call(timer.tick, getTimeString(Duration(seconds: timer.tick)));
      });
    }
  }

  Future<Audiomodel?> send() async {
    isOpened = false;
    if ((timer?.tick ?? 0) < 1) {
      timer?.cancel();
      await recorder.stopRecorder();
      filePath = null;
      return null;
    } else {
      filePath = await recorder.stopRecorder();
      final sec = timer!.tick;
      timer?.cancel();
      return Audiomodel(
        path: filePath!,
        size: 0,
        duration: Duration(seconds: sec),
      );
    }
  }

  cancel() async {
    timer?.cancel();
    if (isOpened) {
      isOpened = false;
      await recorder.stopRecorder();
    }
  }

  String getTimeString(Duration time) {
    final minutes =
        time.inMinutes.remainder(Duration.minutesPerHour).toString();
    final seconds = time.inSeconds
        .remainder(Duration.secondsPerMinute)
        .toString()
        .padLeft(2, '0');
    return time.inHours > 0
        ? "${time.inHours}:${minutes.padLeft(2, "0")}:$seconds"
        : "$minutes:$seconds";
  }
}

class Audiomodel {
  final String path;
  final num size;
  final Duration duration;

  Audiomodel({
    required this.path,
    required this.size,
    required this.duration,
  });
}

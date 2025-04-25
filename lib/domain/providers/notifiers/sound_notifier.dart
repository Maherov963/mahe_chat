import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:io';

class SoundNotifier extends ChangeNotifier {
  Stream<AudioPosition> get positionDataStream =>
      Rx.combineLatest4<Duration, Duration, Duration?, bool, AudioPosition>(
        player.positionStream,
        player.bufferedPositionStream,
        player.durationStream,
        player.playingStream,
        (a, b, c, d) => AudioPosition(
          isPlaying: d,
          position: a,
          bufferedPosition: b,
          duration: c ?? Duration.zero,
        ),
      );
  AudioPlayer player = AudioPlayer();
  String? playingId;

  Future<Uri?> _copyAssetToLocal() async {
    try {
      var content = await rootBundle.load("assets/images/res_log.png");
      final directory = await getApplicationDocumentsDirectory();
      var file = File("${directory.path}/aud.png");
      file.writeAsBytesSync(content.buffer.asUint8List());
      return file.uri;
    } catch (e) {
      return null;
    }
  }

  playAudio(String path) async {
    playingId = path;
    final title = path.split("/").last.split(".").removeLast();
    await player.setAudioSource(
      ConcatenatingAudioSource(
        children: [
          AudioSource.file(
            path,
            tag: MediaItem(
              album: "رسالة صوتية",
              id: "1",
              title: title,
              artUri: await _copyAssetToLocal(),
            ),
          ),
        ],
      ),
    );
    player.playerStateStream.listen((event) async {
      if (event.processingState == ProcessingState.completed) {
        await player.seek(Duration.zero);
        await player.stop();
      }
    });
    player.play();
    notifyListeners();
  }

  pauseAudio() {
    player.pause();
    notifyListeners();
  }

  resumrAudio() {
    player.play();
    notifyListeners();
  }
}

class AudioPosition {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
  final bool isPlaying;
  AudioPosition({
    required this.isPlaying,
    required this.position,
    required this.bufferedPosition,
    required this.duration,
  });
}

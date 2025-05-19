import 'package:mahe_chat/domain/providers/notifiers/sound_notifier.dart';
import 'package:mahe_chat/domain/models/messages/audio_message.dart';
import 'package:mahe_chat/domain/models/user/user.dart';
import 'package:mahe_chat/domain/providers/providers.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioMessageBubble extends StatefulWidget {
  final Profile currentUser;
  final AudioMessage message;
  const AudioMessageBubble({
    super.key,
    required this.message,
    required this.currentUser,
  });

  @override
  State<AudioMessageBubble> createState() => _AudioMessageBubbleState();
}

class _AudioMessageBubbleState extends State<AudioMessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) {
        final value = ref.watch(soundProvider);
        final valueRead = ref.read(soundProvider);
        return StreamBuilder<AudioPosition>(
            stream: value.positionDataStream,
            builder: (context, snapshot) {
              final audioPosition = snapshot.data;
              return Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      if (valueRead.playingId != widget.message.uri) {
                        valueRead.playAudio(widget.message.uri);
                      } else {
                        if (valueRead.player.playing) {
                          valueRead.pauseAudio();
                        } else {
                          valueRead.resumrAudio();
                        }
                      }
                    },
                    icon: value.playingId == widget.message.uri
                        ? Icon(
                            audioPosition?.isPlaying ?? false
                                ? Icons.pause
                                : Icons.play_arrow,
                          )
                        : const Icon(Icons.play_arrow),
                  ),
                  Flexible(
                    child: Padding(
                        padding:
                            const EdgeInsets.only(left: 4, right: 4, top: 4),
                        child: ProgressBar(
                          // thumbColor: color8,
                          thumbRadius: 6,
                          barHeight: 3,
                          timeLabelTextStyle:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                          timeLabelLocation: TimeLabelLocation.sides,
                          // progressBarColor: color8,
                          progress: value.playingId == widget.message.uri
                              ? audioPosition?.position ?? Duration.zero
                              : Duration.zero,
                          total: widget.message.duration,
                          onSeek: value.playingId == widget.message.uri
                              ? valueRead.player.seek
                              : null,
                        )),
                  ),
                ],
              );
            });
      },
    );
  }
}

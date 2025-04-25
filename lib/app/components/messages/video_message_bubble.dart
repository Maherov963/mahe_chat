import 'package:mahe_chat/domain/models/messages/video_message.dart';
import 'package:mahe_chat/domain/models/user/user.dart';
import 'package:flutter/material.dart';

class VideoMessageBubble extends StatelessWidget {
  final VideoMessage message;
  final User currentUser;

  const VideoMessageBubble({
    super.key,
    required this.message,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

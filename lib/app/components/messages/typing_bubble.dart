import 'package:mahe_chat/app/components/messages/circle_avatar._message.dart';
import 'package:mahe_chat/data/extensions/extension.dart';
import 'package:mahe_chat/domain/models/messages/typing_message.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TypingBubble extends StatelessWidget {
  final TypingMessageData data;
  const TypingBubble({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColorLight;
    return Container(
      padding: const EdgeInsets.all(4),
      width: double.infinity,
      child: Row(
        children: [
          10.getWidthSizedBox,
          const UserAvatar(),
          10.getWidthSizedBox,
          LoadingAnimationWidget.waveDots(color: color, size: 25),
        ],
      ),
    );
  }
}

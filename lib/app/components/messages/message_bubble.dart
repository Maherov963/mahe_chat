import 'package:mahe_chat/app/components/messages/audio_message_bubble.dart';
import 'package:mahe_chat/app/components/messages/custom_message_bubble.dart';
import 'package:mahe_chat/app/components/messages/file_message_bubble.dart';
import 'package:mahe_chat/app/components/messages/image_message_bubble.dart';
import 'package:mahe_chat/app/components/messages/message_time.dart';
import 'package:mahe_chat/app/components/messages/reply_message.dart';
import 'package:mahe_chat/app/components/messages/system_message_bubble.dart';
import 'package:mahe_chat/app/components/messages/text_message_bubble.dart';
import 'package:mahe_chat/app/components/messages/video_message_bubble.dart';
import 'package:mahe_chat/domain/models/messages/audio_message.dart';
import 'package:mahe_chat/domain/models/messages/custom_message.dart';
import 'package:mahe_chat/domain/models/messages/file_message.dart';
import 'package:mahe_chat/domain/models/messages/image_message.dart';
import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:mahe_chat/domain/models/messages/system_message.dart';
import 'package:mahe_chat/domain/models/messages/video_message.dart';
import 'package:mahe_chat/domain/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool previousSameAuthor;
  final int messageWidth;
  final User currentUser;
  final void Function(Message)? onSwipe;
  final void Function(int)? onReplyTap;
  final void Function(Message)? onMessageTap;
  const MessageBubble({
    super.key,
    required this.message,
    required this.messageWidth,
    required this.currentUser,
    this.onSwipe,
    required this.previousSameAuthor,
    this.onMessageTap,
    this.onReplyTap,
  });

  Widget _messageBuilder(String extraSpace, TextStyle textStyle) {
    switch (message.type) {
      case MessageType.audio:
        final audioMessage = message as AudioMessage;
        return AudioMessageBubble(
          message: audioMessage,
          currentUser: currentUser,
        );
      case MessageType.custom:
        final customMessage = message as CustomMessage;
        return CustomMessageBubble(
          message: customMessage,
          currentUser: currentUser,
        );
      case MessageType.file:
        final fileMessage = message as FileMessage;
        return FileMessageBubble(
          message: fileMessage,
          currentUser: currentUser,
        );
      case MessageType.image:
        final imageMessage = message as ImageMessage;
        return ImageMessageBubble(
          messageWidth: messageWidth,
          message: imageMessage,
          currentUser: currentUser,
        );
      case MessageType.system:
        final systemMessage = message as SystemMessage;
        return SystemMessageBubble(
          message: systemMessage,
          messageWidth: messageWidth,
          currentUser: currentUser,
        );
      case MessageType.text:
        final textMessage = message as TextMessage;
        return TextMessageBubble(
          message: textMessage,
          style: textStyle,
          extraSpace: extraSpace,
          currentUser: currentUser,
        );
      case MessageType.unsupported:
        final textMessage = message as TextMessage;
        return TextMessageBubble(
          style: textStyle,
          message: textMessage,
          extraSpace: "",
          currentUser: currentUser,
        );
      case MessageType.video:
        final videoMessage = message as VideoMessage;
        return VideoMessageBubble(
          message: videoMessage,
          currentUser: currentUser,
        );
    }
  }

  num textMessageWidth(TextStyle style) {
    if (message is TextMessage) {
      final textMessge = message as TextMessage;
      final messageText = textMessge.text;
      return textWidth(messageText, style);
    } else {
      return messageWidth;
    }
  }

  num replyWidth(TextStyle style) {
    if (message.replyPreview != null) {
      // if (message.repliedMessage is TextMessage) {
      return textWidth((message.replyPreview as TextMessage).text,
          style.copyWith(fontSize: 10));
      // } else {
      //   return messageWidth;
      // }
    } else {
      return 0;
    }
  }

  int getLargerNum(num a, num b, num c) {
    if (a >= b && a >= c) {
      return a.toInt();
    } else if (b >= a && b >= c) {
      return b.toInt();
    } else {
      return c.toInt();
    }
  }

  @override
  Widget build(BuildContext context) {
    // log("message");
    final theme = Theme.of(context);
    TextStyle textStyle = theme.textTheme.bodySmall!.copyWith(fontSize: 13);

    TextStyle timeStyle = textStyle.copyWith(fontSize: 10, color: Colors.grey);
    TextStyle replyStyle =
        textStyle.copyWith(fontSize: 10, color: theme.colorScheme.primary);

    final bool isMine = currentUser.id == message.author.id;
    final timeText =
        DateFormat(DateFormat.HOUR_MINUTE).format(message.createdAt!);
    final timeWidth = textWidth(timeText, timeStyle) + (isMine ? 18 : 0);
    final whiteSpaceWidth = textWidth(' ', textStyle);
    final extraSpaceCount = ((timeWidth / whiteSpaceWidth).round()) + (2);
    final extraSpace = '${' ' * extraSpaceCount}\u202f';
    final extraSpaceWidth = textWidth(extraSpace, textStyle);
    final widthReply = replyWidth(replyStyle) + 12;
    final widthText = textMessageWidth(textStyle);
    final widthName = (isMine || previousSameAuthor)
        ? 0
        : textWidth(
                message.author.getFullName, textStyle.copyWith(fontSize: 10)) +
            8;
    final isTimeInSameLine =
        widthText + extraSpaceWidth < (messageWidth - 16) ||
            widthText > (messageWidth - 16);
    final int minimumWidth = isTimeInSameLine
        ? getLargerNum(widthText + extraSpaceWidth + 8, widthReply, widthName)
        : getLargerNum(widthText + 8, widthReply, widthName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMine && !previousSameAuthor)
          Padding(
            padding: const EdgeInsets.only(top: 2, left: 4, right: 4),
            child: Text(
              message.author.getFullName,
              style: textStyle.copyWith(
                  color: Theme.of(context).colorScheme.primary, fontSize: 10),
            ),
          ),
        if (message.replyPreview != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
            child: ReplyMessage(
              replyPreview: message.replyPreview!,
              onReplyTap: onReplyTap,
              currentUser: currentUser,
              maxWidth: messageWidth,
              minWidth: minimumWidth,
              style: replyStyle,
            ),
          ),
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(4).copyWith(
                bottom: isTimeInSameLine ? 6 : 20,
              ),
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: minimumWidth.toDouble(),
                  ),
                  child: _messageBuilder(
                    isTimeInSameLine ? extraSpace : "",
                    textStyle,
                  )),
            ),
            Positioned.directional(
              textDirection: Directionality.of(context),
              bottom: 5,
              end: 7,
              child: MessageTime(
                message: message,
                isMine: isMine,
                style: timeStyle,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Returns the width of given `text` using TextPainter
  double textWidth(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.rtl,
    )..layout();
    return textPainter.width;
  }
}




/*

            // Deciding the placement of time text.

            //                                      maxWidth
            //                                         |
            // Short message                           v
            // |---------------|
            // | MESSAGE  time |
            // |---------------|

            // text + extraSpace < maxWidth
            // |---------------------------------------|
            // | MESSAGE.MESSAGE.MESSAGE.MESSAGE  time |
            // |---------------------------------------|

            // text < maxWidth
            // |---------------------------------------|
            // | MESSAGE.MESSAGE.MSGS..MESSAGE.MESSAGE |
            // |                                  time |
            // |---------------------------------------|

            // text > maxWidth
            // |---------------------------------------|
            // | MESSAGE.MESSAGE.MSGS..MESSAGE.MESSAGE |
            // | MESSAGE.MESSAGE.MESSAGE          time |
            // |---------------------------------------|*/
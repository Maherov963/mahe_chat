import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahe_chat/domain/models/messages/reply_preview.dart';
import 'package:mahe_chat/domain/models/user/user.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:mahe_chat/features/auth/domain/provider/auth_notifier.dart';
=======
<<<<<<< HEAD:lib/app/components/messages/reply_message.dart
import 'package:mahe_chat/domain/providers/providers.dart';
=======
import 'package:mahe_chat/features/auth/domain/provider/auth_notifier.dart';
>>>>>>> origin/main:lib/features/chat/presentation/components/messages/reply_message.dart
>>>>>>> c3d9dd8539a2befed8f17a57d564e16b58c371f0

class ReplyMessage extends ConsumerWidget {
  const ReplyMessage({
    super.key,
    required this.replyPreview,
    this.onReplyTap,
    this.withCancel = false,
    this.onCloseReply,
    required this.currentUser,
    this.style,
    this.minWidth,
    this.maxWidth,
  });
  final bool withCancel;
  final void Function(int)? onReplyTap;
  final void Function()? onCloseReply;
  final ReplyPreview? replyPreview;
  final Profile currentUser;
  final int? minWidth;
  final int? maxWidth;
  final TextStyle? style;

  Widget _buildReply() {
    // switch (message?.type) {
    //   case MessageType.image:
    //     return const Row(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Icon(
    //           Icons.photo,
    //           color: Colors.grey,
    //           size: 20,
    //         ),
    //         Text(
    //           " Photo",
    //           style: TextStyle(color: Colors.grey),
    //         ),
    //       ],
    //     );
    //   case MessageType.file:
    //     final fileMessage = message as FileMessage;
    //     return Row(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         const Icon(
    //           Icons.description,
    //           color: Colors.grey,
    //           size: 20,
    //         ),
    //         Text(
    //           fileMessage.name,
    //           style: const TextStyle(color: Colors.grey),
    //         ),
    //       ],
    //     );
    //   case MessageType.audio:
    //     final audioMessage = message as AudioMessage;
    //     return Row(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         const Icon(
    //           Icons.mic,
    //           color: Colors.grey,
    //           size: 20,
    //         ),
    //         Text(
    //           "Voice message (${getTimeString(audioMessage.duration)})",
    //           style: const TextStyle(color: Colors.grey),
    //         ),
    //       ],
    //     );
    //   case MessageType.text:
    //     final textMessage = message as TextMessage;
    return Text(
      replyPreview?.text ?? "error",
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: style?.copyWith(color: Colors.grey),
    );
    //   default:
    //     return Text(message?.type.toString() ?? "error");
    // }
  }

  @override
  Widget build(context, ref) {
    final me = ref.read(authProvider.notifier).myUser!;
    final isMine = replyPreview?.senderId == me.id;
    final theme = Theme.of(context).colorScheme;
    final color = isMine ? theme.primary : theme.inversePrimary;
    return InkWell(
      onTap: onReplyTap == null
          ? null
          : () {
<<<<<<< HEAD
              // onReplyTap!(replyPreview!.id);
=======
<<<<<<< HEAD:lib/app/components/messages/reply_message.dart
              onReplyTap!(replyPreview!.id);
=======
              // onReplyTap!(replyPreview!.id);
>>>>>>> origin/main:lib/features/chat/presentation/components/messages/reply_message.dart
>>>>>>> c3d9dd8539a2befed8f17a57d564e16b58c371f0
            },
      child: CustomPaint(
        painter: MyPaint(color: color),
        child: Container(
          constraints: BoxConstraints(
            minWidth: (minWidth?.toDouble() ?? 0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color.withOpacity(0.1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              withCancel
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isMine ? "You" : replyPreview?.senderName ?? "",
                          style: style?.copyWith(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        InkWell(
                          onTap: onCloseReply,
                          child: const Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 18,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      isMine ? "You" : replyPreview!.senderName,
                      style: style,
                    ),
              _buildReply(),
            ],
          ),
        ),
      ),
    );
  }
}

class MyPaint extends CustomPainter {
  final Color color;

  MyPaint({super.repaint, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final RRect bubbleBody = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, 4, size.height),
      bottomLeft: const Radius.circular(10),
      topLeft: const Radius.circular(10),
    );
    canvas.drawRRect(bubbleBody, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

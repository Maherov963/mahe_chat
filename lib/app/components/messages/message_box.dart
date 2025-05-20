import 'package:mahe_chat/app/components/messages/message_bubble.dart';
import 'package:mahe_chat/app/utils/plugins/my_swipe.dart';
import 'package:mahe_chat/data/extensions/extension.dart';
import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:mahe_chat/domain/models/user/user.dart';
import 'package:mahe_chat/domain/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'circle_avatar._message.dart';

class MessageBox extends ConsumerStatefulWidget {
  const MessageBox({
    super.key,
    required this.message,
    required this.messageWidth,
    required this.currentUser,
    this.onSwipe,
    required this.previousSameAuthor,
    this.onMessageTap,
    this.onReplyTap,
  });
  final Message message;
  final bool previousSameAuthor;
  final int messageWidth;
  final Profile currentUser;
  final void Function(Message)? onSwipe;
  final void Function(int)? onReplyTap;
  final void Function(Message)? onMessageTap;

  @override
  ConsumerState<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends ConsumerState<MessageBox> {
  trigDirectionality(TextDirection d) {
    if (d == TextDirection.ltr) {
      return TextDirection.rtl;
    } else {
      return TextDirection.ltr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final select = ref.watch(messageSelectProvider);
    final selectRead = ref.read(messageSelectProvider.notifier);
    final bool isMine = widget.currentUser.id == widget.message.author.id;
    final directionality = isMine
        ? trigDirectionality(Directionality.of(context))
        : Directionality.of(context);
    return MySwipe(
      onLongPress: () {
        selectRead.toggle(widget.message.id);
      },
      onTap: () {
        if (select.isNotEmpty) {
          selectRead.toggle(widget.message.id);
        } else {
          widget.onMessageTap?.call(widget.message);
        }
      },
      isMine: isMine,
      onSwipe: () {
        widget.onSwipe?.call(widget.message);
      },
      child: Container(
        width: widget.messageWidth.toDouble(),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: directionality,
          children: [
            if (!isMine)
              widget.previousSameAuthor
                  ? 30.getWidthSizedBox
                  : const UserAvatar(),
            if (!isMine) 10.getWidthSizedBox,
            ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: widget.messageWidth.toDouble()),
              child: CustomPaint(
                painter: CustomChatBubble(
                  previousSameAuthor: widget.previousSameAuthor,
                  textDirection: directionality,
                  color: isMine
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.surfaceContainer,
                  isOwn: isMine,
                ),
                child: MessageBubble(
                  message: widget.message,
                  messageWidth: widget.messageWidth,
                  currentUser: widget.currentUser,
                  previousSameAuthor: widget.previousSameAuthor,
                  onReplyTap: select.isEmpty ? widget.onReplyTap : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomChatBubble extends CustomPainter {
  CustomChatBubble({
    required this.color,
    required this.isOwn,
    required this.previousSameAuthor,
    required this.textDirection,
  });
  final TextDirection? textDirection;
  final Color color;
  final bool isOwn;
  final bool previousSameAuthor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final RRect bubbleBody = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(10));
    canvas.drawPath(
        Path()
          ..addRRect(bubbleBody)
          ..fillType = PathFillType.evenOdd,
        Paint()
          ..color = Colors.black.withAlpha(150)
          ..maskFilter =
              MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(3)));
    if (!previousSameAuthor) {
      Path paintBubbleTail() {
        late Path path;

        if (isOwn) {
          if (textDirection == TextDirection.ltr) {
            //for arabic

            path = Path()
              ..moveTo(10, size.height)
              ..quadraticBezierTo(0, size.height, -10, size.height - 0)
              ..quadraticBezierTo(0, size.height - 10, 0, size.height - 15);
          } else {
            //for english

            path = Path()
              ..moveTo(size.width - 10, size.height)
              ..quadraticBezierTo(
                  size.width, size.height, size.width + 7, size.height - 0)
              ..quadraticBezierTo(
                  size.width, size.height - 10, size.width, size.height - 15);
          }
        } else {
          if (textDirection == TextDirection.ltr) {
            //for english
            path = Path()
              ..moveTo(10, 0)
              ..quadraticBezierTo(-5, 0, -10, 0)
              ..quadraticBezierTo(-5, 10, 0, 15);
          } else {
            //for arabic

            path = Path()
              ..moveTo(size.width + 10, 0)
              ..quadraticBezierTo(size.width - 5, 0, size.width - 10, 0)
              ..quadraticBezierTo(size.width - 5, 10, size.width, 15);
          }
        }

        return path;
      }

      final Path bubbleTail = paintBubbleTail();
      canvas.drawPath(
          Path()
            ..addPath(bubbleTail, Offset.zero)
            ..fillType = PathFillType.evenOdd,
          Paint()
            ..color = Colors.black.withAlpha(150)
            ..maskFilter =
                MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(3)));

      canvas.drawPath(bubbleTail, paint);
    }

    canvas.drawRRect(bubbleBody, paint);
  }

  static double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

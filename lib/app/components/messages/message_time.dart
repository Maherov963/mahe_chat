import 'package:mahe_chat/app/components/messages/message_status_icon.dart';
import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageTime extends StatelessWidget {
  const MessageTime({
    super.key,
    required this.message,
    required this.isMine,
    required this.style,
  });
  final Message message;
  final bool isMine;
  final TextStyle style;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isMine)
          MessageStatusIcon(
            status: message.status,
            onResend: () {
              // context.read<ChatProvider>().emitMessage(message);
            },
          ),
        Text(DateFormat(DateFormat.HOUR_MINUTE).format(message.createdAt!),
            style: style),
      ],
    );
  }
}

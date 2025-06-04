import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:flutter/material.dart';

/// Show icon based on [Message.status]
class MessageStatusIcon extends StatelessWidget {
  const MessageStatusIcon({
    Key? key,
    required this.status,
    required this.onResend,
  }) : super(key: key);

  final Status? status;
  final Function()? onResend;

  @override
  Widget build(BuildContext context) {
    const padding = 2.0;
    // Size difference between done icon and access_time icon.
    const iconSizeDifference = 4.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: status == Status.sending
            ? padding + 2 // 2 -> iconSizeDifference / 2
            : padding,
      ),
      child: InkWell(
        onTap: status == Status.error ? null : onResend,
        child: Icon(
          _getStatusIcon(status),
          size: status == Status.sending ? 18 - iconSizeDifference : 18,
          color: status == Status.seen
              ? Theme.of(context).colorScheme.tertiary
              : status == Status.error
                  ? Colors.red
                  : Colors.grey,
        ),
      ),
    );
  }

  /// Return appropriate icon for message status
  IconData _getStatusIcon(Status? status) {
    switch (status) {
      case Status.sending:
        return Icons.access_time;
      case Status.sent:
        return Icons.done;
      case Status.delivered:
      case Status.seen:
        return Icons.done_all;
      case Status.error:
        return Icons.error_outline;
      default:
        return Icons.done_all;
    }
  }
}

import 'package:mahe_chat/domain/models/messages/system_message.dart';
import 'package:mahe_chat/domain/models/user/user.dart';
import 'package:flutter/material.dart';

class SystemMessageBubble extends StatelessWidget {
  final SystemMessage message;
  final User currentUser;
  final int messageWidth;
  const SystemMessageBubble({
    super.key,
    required this.message,
    required this.currentUser,
    required this.messageWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        constraints: BoxConstraints(maxWidth: messageWidth.toDouble()),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onInverseSurface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurStyle: BlurStyle.outer,
              blurRadius: 2,
            )
          ],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          message.text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary, fontSize: 12),
        ),
      ),
    );
  }
}

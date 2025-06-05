import 'package:mahe_chat/domain/models/messages/custom_message.dart';
import 'package:mahe_chat/domain/models/user/user.dart';
import 'package:flutter/material.dart';

class CustomMessageBubble extends StatelessWidget {
  final CustomMessage message;
  final Profile currentUser;

  const CustomMessageBubble({
    super.key,
    required this.message,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

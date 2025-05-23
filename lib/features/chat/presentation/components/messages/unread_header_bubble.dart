import 'package:mahe_chat/domain/models/messages/unread_header.dart';
import 'package:flutter/material.dart';

class UnreadHeader extends StatelessWidget {
  final UnreadHeaderData data;
  const UnreadHeader({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onInverseSurface;
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      color: color.withOpacity(0.3),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          '${data.count} Unread Messages',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

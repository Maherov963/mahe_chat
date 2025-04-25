import 'package:mahe_chat/domain/models/messages/date_header.dart';
import 'package:flutter/material.dart';

class DateBubble extends StatelessWidget {
  const DateBubble({super.key, required this.dateHeader});
  final DateHeader dateHeader;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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
          dateHeader.text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }
}

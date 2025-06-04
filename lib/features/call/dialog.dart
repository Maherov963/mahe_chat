import 'package:flutter/material.dart';
import 'package:mahe_chat/features/call/signaling.dart';

void showIncomingCallDialog(
    BuildContext context, String callerId, String roomId, Signaling signaling) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text('مكالمة واردة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('لديك مكالمة من: $callerId'),
            SizedBox(height: 16),
            Icon(Icons.video_call, size: 48, color: Colors.green),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await signaling.answerCall(roomId);
            },
            child: Text('قبول', style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await signaling.rejectCall(roomId);
            },
            child: Text('رفض', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}

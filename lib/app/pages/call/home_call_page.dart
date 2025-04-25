import 'package:mahe_chat/app/pages/call/call_card.dart';
import 'package:flutter/material.dart';

class HomeCallPage extends StatelessWidget {
  const HomeCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 14,
      itemBuilder: (context, index) => CallCard(
        index: index,
        callState: CallState.values[index % 4],
      ),
    );
  }
}

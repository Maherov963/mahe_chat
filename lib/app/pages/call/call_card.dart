import 'package:mahe_chat/app/components/certified_account.dart';
import 'package:mahe_chat/app/components/icon_text_c_button.dart';
import 'package:mahe_chat/app/components/image_handler.dart';
import 'package:mahe_chat/app/pages/chat_page/home_chat_page.dart';
import 'package:mahe_chat/app/utils/assets/assets_images.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CallCard extends StatelessWidget {
  const CallCard({super.key, required this.index, required this.callState});
  final int index;
  final CallState callState;

  Widget get buildCallState {
    switch (callState) {
      case CallState.incoming:
        return const Icon(
          Icons.call_received,
          size: 18,
        );
      case CallState.declined:
        return const Icon(
          Icons.call_made,
          size: 18,
        );
      case CallState.missed:
        return const Icon(
          Icons.call_received,
          size: 18,
        );
      case CallState.outgoing:
        return const Icon(
          Icons.call_made,
          size: 18,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const CertifiedAccount(name: "Maher ghieh", certified: true),
      leading: ImageHandler(
        path: AssetImg.mine,
        isCircular: true,
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => MyDialog(
              tag: index,
            ),
          );
        },
      ),
      subtitle: Row(
        children: [
          buildCallState,
          Text(DateFormat("d , MMMM H:mm").format(DateTime.now()))
        ],
      ),
      trailing: const IconTextCButton(icon: Icons.call),
    );
  }
}

enum CallState {
  declined,
  missed,
  incoming,
  outgoing,
}

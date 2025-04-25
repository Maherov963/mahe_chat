import 'package:mahe_chat/device/utils.dart';
import 'package:mahe_chat/domain/models/messages/file_message.dart';
import 'package:mahe_chat/domain/models/user/user.dart';
import 'package:flutter/material.dart';

class FileMessageBubble extends StatelessWidget {
  final FileMessage message;
  final User currentUser;

  const FileMessageBubble({
    super.key,
    required this.message,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "File",
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(
          4,
          4,
          5,
          0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(21),
              ),
              height: 42,
              width: 42,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (message.isLoading ?? false)
                    const Positioned.fill(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                        strokeWidth: 3,
                      ),
                    ),
                  const Icon(Icons.file_copy)
                ],
              ),
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsetsDirectional.only(
                  start: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.name,
                      // style: user.id == message.author.id
                      //     ? InheritedChatTheme.of(context)
                      //         .theme
                      //         .sentMessageBodyTextStyle
                      //     : InheritedChatTheme.of(context)
                      //         .theme
                      //         .receivedMessageBodyTextStyle,
                      textWidthBasis: TextWidthBasis.longestLine,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 4,
                      ),
                      child: Text(
                        formatBytes(message.size.truncate()),
                        // style: user.id == message.author.id
                        //     ? InheritedChatTheme.of(context)
                        //         .theme
                        //         .sentMessageCaptionTextStyle
                        //     : InheritedChatTheme.of(context)
                        //         .theme
                        //         .receivedMessageCaptionTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

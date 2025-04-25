import 'package:mahe_chat/app/components/image_handler.dart';
import 'package:mahe_chat/app/components/image_view.dart';
import 'package:mahe_chat/device/utils.dart';
import 'package:mahe_chat/domain/models/messages/image_message.dart';
import 'package:mahe_chat/domain/models/user/user.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';

class ImageMessageBubble extends StatefulWidget {
  final ImageMessage message;
  final User currentUser;
  final int messageWidth;

  const ImageMessageBubble({
    super.key,
    required this.message,
    required this.currentUser,
    required this.messageWidth,
  });

  @override
  State<ImageMessageBubble> createState() => _ImageMessageBubbleState();
}

class _ImageMessageBubbleState extends State<ImageMessageBubble> {
  Size _size = Size.zero;

  @override
  Widget build(BuildContext context) {
    _size = Size(widget.message.width ?? 0, widget.message.height ?? 0);
    if (_size.aspectRatio == 0) {
      return Container(
        color: Colors.grey,
        height: _size.height,
        width: _size.width,
      );
    } else if (_size.aspectRatio < 0.1 || _size.aspectRatio > 10) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 64,
            margin: const EdgeInsetsDirectional.fromSTEB(
              4,
              4,
              8,
              4,
            ),
            width: 64,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: ImageHandler(
                  path: widget.message.uri,
                  isCircular: false,
                )),
          ),
          Flexible(
            child: Container(
              margin: const EdgeInsetsDirectional.fromSTEB(0, 5, 5, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.message.name,
                    textWidthBasis: TextWidthBasis.longestLine,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 4,
                    ),
                    child: Text(
                      formatBytes(widget.message.size.truncate()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return Container(
        constraints: BoxConstraints(
          maxHeight: widget.messageWidth.toDouble(),
          minWidth: 170,
        ),
        child: AspectRatio(
          aspectRatio: _size.aspectRatio > 0 ? _size.aspectRatio : 1,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: ImageHandler(
                path: widget.message.uri,
                isCircular: false,
                onTap: () {
                  context.pushTransparentRoute(
                    MyImageView(
                      name: widget.message.author.getFullName,
                      link: widget.message.uri,
                    ),
                  );
                },
              )),
        ),
      );
    }
  }
}

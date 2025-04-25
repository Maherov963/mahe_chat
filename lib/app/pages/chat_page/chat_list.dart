import 'package:mahe_chat/app/pages/chat_page/chat.dart';
import 'package:mahe_chat/app/utils/widgets/my_filled_icon.dart';
import 'package:mahe_chat/domain/models/messages/date_header.dart';
import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:mahe_chat/domain/models/messages/typing_message.dart';
import 'package:mahe_chat/domain/models/messages/unread_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ChatList extends StatelessWidget {
  final List<Object> messages;
  final AutoScrollController scrollController;
  final Widget Function(Object, int index) itemBuilder;
  const ChatList({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        ListView.custom(
          controller: scrollController,
          reverse: true,
          childrenDelegate: SliverChildBuilderDelegate(
            (context, index) {
              final indx = messages.length - 1 - index;
              return itemBuilder(messages[indx], indx);
            },
            childCount: messages.length,
            findChildIndexCallback: (key) {
              final valueKey = key as ValueKey;
              final index = messages.indexWhere((e) {
                if (e is DateHeader) {
                  return e.dateTime == valueKey.value;
                } else if (e is UnreadHeaderData) {
                  return unreadHeader == valueKey.value;
                } else if (e is TypingMessageData) {
                  return TypingMessageData.id == valueKey.value;
                } else {
                  e as Map;
                  final message = e["message"] as Message;
                  return message.id.toString() == valueKey.value;
                }
              });
              final indx = messages.length - 1 - index;
              return index == -1 ? null : indx;
            },
          ),
        ),
        ArrowButton(controller: scrollController),
      ],
    );
  }
}

class ArrowButton extends StatefulWidget {
  const ArrowButton({
    super.key,
    required this.controller,
  });
  final AutoScrollController controller;
  @override
  State<ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<ArrowButton> {
  bool isShown = false;

  void listner() {
    final isForward = widget.controller.position.userScrollDirection;
    final newIsShown = !widget.controller.isIndexStateInLayoutRange(0) &&
        isForward == ScrollDirection.forward;
    if (newIsShown != isShown) {
      isShown = newIsShown;
      setState(() {});
    }
  }

  @override
  void initState() {
    widget.controller.addListener(listner);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(listner);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: Offset(isShown ? 0 : 1, 0),
      duration: Durations.short4,
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: MyFilledIcon(
          icon: Icons.keyboard_double_arrow_down_rounded,
          color: Colors.grey,
          fillColor: Theme.of(context).colorScheme.onInverseSurface,
          onTap: () {
            widget.controller.jumpTo(0);
          },
        ),
      ),
    );
  }
}

import 'dart:math';
import 'package:mahe_chat/app/components/messages/date_bubble.dart';
import 'package:mahe_chat/app/components/messages/message_box.dart';
import 'package:mahe_chat/app/components/messages/system_message_bubble.dart';
import 'package:mahe_chat/app/components/messages/typing_bubble.dart';
import 'package:mahe_chat/app/components/messages/unread_header_bubble.dart';
import 'package:mahe_chat/app/components/my_snackbar.dart';
import 'package:mahe_chat/app/pages/chat_page/chat_list.dart';
import 'package:mahe_chat/app/utils/plugins/calculate_message_list.dart';
import 'package:mahe_chat/domain/models/messages/date_header.dart';
import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:mahe_chat/domain/models/messages/system_message.dart';
import 'package:mahe_chat/domain/models/messages/typing_message.dart';
import 'package:mahe_chat/domain/models/messages/unread_header.dart';
import 'package:mahe_chat/domain/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

final Map<String, int> chatMessageAutoScrollIndexById = {};
const unreadHeader = "UN_READ_HEADER";

class Chat extends ConsumerStatefulWidget {
  final List<Message> messages;
  final User user;
  final AutoScrollController controller;
  final void Function(Message)? handleSwipe;
  final void Function(Message)? handleMessageTap;
  const Chat({
    super.key,
    required this.messages,
    required this.controller,
    required this.user,
    required this.handleSwipe,
    required this.handleMessageTap,
  });

  @override
  ConsumerState<Chat> createState() => _ChatState();
}

class _ChatState extends ConsumerState<Chat> {
  List<Object> _chatMessages = [];
  int oldLeangth = 0;
  bool scrolledToUnread = false;

  @override
  void didUpdateWidget(covariant Chat oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldLeangth != widget.messages.length) {
      oldLeangth = widget.messages.length;
      final result = calculateChatMessages(
        widget.messages,
        lastReadMessageId: null,
      );
      _chatMessages = result;
      _refreshAutoScrollMapping();
      _scrollToUnread();
    }
  }

  void _refreshAutoScrollMapping() {
    chatMessageAutoScrollIndexById.clear();
    var i = 0;
    for (final object in _chatMessages) {
      if (object is DateHeader) {
        chatMessageAutoScrollIndexById[object.dateTime.toString()] =
            _chatMessages.length - 1 - i;
      } else if (object is Map<String, Object>) {
        final message = object['message']! as Message;
        chatMessageAutoScrollIndexById[message.id.toString()] =
            _chatMessages.length - 1 - i;
      } else if (object is UnreadHeaderData) {
        chatMessageAutoScrollIndexById[unreadHeader] =
            _chatMessages.length - 1 - i;
      } else if (object is TypingMessageData) {
        chatMessageAutoScrollIndexById[TypingMessageData.id] =
            _chatMessages.length - 1 - i;
      }
      i++;
    }
  }

  void _scrollToMessage(int id, int currentIndex) async {
    final isExist = widget.messages.where((e) => e.id == id).isNotEmpty;
    if (!isExist) {
      MySnackBar.showMySnackBar("this message does not exist anymore");
      return;
    }
    final index = chatMessageAutoScrollIndexById[id.toString()]!;
    _scrollToIndex(index, currentIndex, highlight: true);
  }

  void _scrollToUnread() async {
    if (scrolledToUnread) {
      return;
    }
    final index = chatMessageAutoScrollIndexById[unreadHeader];
    if (index == null) {
      return;
    }
    scrolledToUnread = true;
    _scrollToIndex(index, 0);
  }

  void _scrollToIndex(int index, int currentIndex,
      {bool highlight = false}) async {
    // print(index);
    // print(currentIndex);
    // print(widget.controller.offset);
    if (index > currentIndex + 50) {
      widget.controller.jumpTo(50.0 * index);
    }
    await widget.controller
        .scrollToIndex(index, duration: const Duration(milliseconds: 1));
    if (highlight) {
      widget.controller.cancelAllHighlights();
      await widget.controller.highlight(index);
    }
  }

  @override
  void initState() {
    didUpdateWidget(widget);
    super.initState();
  }

  Widget _messageBuilder(
    Object object,
    int messageWidth,
    int index,
  ) {
    if (object is DateHeader) {
      return AutoScrollTag(
        controller: widget.controller,
        index: _chatMessages.length - 1 - index,
        key: ValueKey(object.dateTime),
        child: DateBubble(dateHeader: object),
      );
    } else if (object is UnreadHeaderData) {
      return UnreadHeader(data: object);
    } else if (object is TypingMessageData) {
      return AutoScrollTag(
        controller: widget.controller,
        index: _chatMessages.length - 1 - index,
        key: const ValueKey(TypingMessageData.id),
        child: TypingBubble(data: object),
      );
    } else {
      final map = object as Map<String, Object>;
      final message = map["message"] as Message;
      final previousSameAuthor = map["previousSameAuthor"] as bool;
      final Widget messageWidget;

      if (message is SystemMessage) {
        messageWidget = SystemMessageBubble(
          message: message,
          currentUser: widget.user,
          messageWidth: messageWidth,
        );
      } else {
        messageWidget = MessageBox(
          message: message,
          previousSameAuthor: previousSameAuthor,
          onSwipe: widget.handleSwipe,
          onMessageTap: widget.handleMessageTap,
          messageWidth: messageWidth,
          currentUser: widget.user,
          onReplyTap: (p0) {
            _scrollToMessage(p0, _chatMessages.length - 1 - index);
          },
        );
      }
      return AutoScrollTag(
        controller: widget.controller,
        index: _chatMessages.length - 1 - index,
        key: ValueKey(message.id.toString()),
        highlightColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        child: messageWidget,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageWidth =
        min(MediaQuery.of(context).size.width * 0.72, 440).floor();

    return ChatList(
      scrollController: widget.controller,
      messages: _chatMessages,
      itemBuilder: (Object item, int index) => _messageBuilder(
        item,
        messageWidth,
        index,
      ),
    );
  }
}

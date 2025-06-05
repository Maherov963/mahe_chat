import 'dart:developer';
import 'package:mahe_chat/data/extensions/extension.dart';
import 'package:mahe_chat/domain/models/messages/date_header.dart';
import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:mahe_chat/domain/models/messages/system_message.dart';
import 'package:mahe_chat/domain/models/messages/unread_header.dart';

const String firstSystemMessage =
    "Messages in this chat are end-to-end encrypted no one except people in this chat and god can read or listen to them.";

List<Object> calculateChatMessages(
  List<Message> messages, {
  String? lastReadMessageId,
}) {
  log(messages.length.toString());
  final chatMessages = <Object>[];

  for (var i = 0; i < messages.length; i++) {
    final isFirst = i == 0;
    final isLast = i == messages.length - 1;
    final message = messages[i];
    final messageHasCreatedAt = message.createdAt != null;

    final nextMessage = isLast ? null : messages[i + 1];
    // final previousMessage = isFirst ? null : messages[i + 1];
    final nextMessageHasCreatedAt = nextMessage?.createdAt != null;

    var nextMessageDateThreshold = false;
    var nextMessageDifferentDay = false;
    var previousSameAuthor = false;

    if (messageHasCreatedAt && nextMessageHasCreatedAt) {
      nextMessageDifferentDay =
          message.createdAt!.day != nextMessage?.createdAt?.day;
    }

    if (isFirst && messageHasCreatedAt) {
      chatMessages.add(
        DateHeader(
          dateTime: message.createdAt!,
          text: message.createdAt!.getYYYYMMDD(),
        ),
      );
      chatMessages.add({
        "previousSameAuthor": false,
        "message": SystemMessage(
          id: "0",
          text: firstSystemMessage,
          createdAt: message.createdAt!,
        ),
      });
    }
    if (!isLast &&
        nextMessage?.author == message.author &&
        nextMessage?.createdAt?.day == message.createdAt?.day &&
        message.id != lastReadMessageId) {
      previousSameAuthor = true;
    }

    chatMessages.add({
      "message": message,
      "previousSameAuthor": previousSameAuthor,
    });

    if (nextMessageDifferentDay || nextMessageDateThreshold) {
      chatMessages.add(DateHeader(
        dateTime: nextMessage!.createdAt!,
        text: nextMessage.createdAt!.getYYYYMMDD(),
      ));
    }

    if (message.id == lastReadMessageId && !isLast) {
      chatMessages.add(UnreadHeaderData(count: messages.length - i - 1));
    }
  }
  // chatMessages.add(const TypingMessageData(name: "Maherov"));
  return chatMessages;
}

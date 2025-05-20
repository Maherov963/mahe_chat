import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:mahe_chat/domain/models/user/user.dart';

import 'reply_preview.dart';

class CustomMessage extends Message {
  CustomMessage({
    required super.author,
    super.createdAt,
    required super.id,
    super.metadata,
    super.remoteId,
    super.replyPreview,
    super.roomId,
    super.showStatus,
    super.status,
    MessageType? type,
    super.updatedAt,
  }) : super(type: type ?? MessageType.custom);

  /// Creates a custom message from a map (decoded JSON).
  // factory CustomMessage.fromJson(Map<String, dynamic> json) =>
  //     _$CustomMessageFromJson(json);

  @override
  Map<String, dynamic> toJson() => {};

  @override
  Message copyWith({
    Profile? author,
    DateTime? createdAt,
    int? id,
    Map<String, dynamic>? metadata,
    int? remoteId,
    ReplyPreview? replyPreview,
    int? roomId,
    bool? showStatus,
    Status? status,
    String? text,
    DateTime? updatedAt,
  }) {
    return this;
  }

  @override
  ReplyPreview getPreivew() {
    return ReplyPreview(
      id: id,
      senderId: author.id,
      senderName: author.username!,
      text: "",
    );
  }
}

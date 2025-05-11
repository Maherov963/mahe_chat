import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:mahe_chat/domain/models/messages/reply_preview.dart';
import 'package:mahe_chat/domain/models/user/user.dart';

class UnsupportedMessage extends Message {
  /// Creates an unsupported message.
  UnsupportedMessage({
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
  }) : super(type: type ?? MessageType.unsupported);

  /// Creates an unsupported message from a map (decoded JSON).
  // factory UnsupportedMessage.fromJson(Map<String, dynamic> json) =>
  //     _$UnsupportedMessageFromJson(json);

  /// Converts an unsupported message to the map representation,
  /// encodable to JSON.
  @override
  Map<String, dynamic> toJson() => {};

  @override
  Message copyWith({
    User? author,
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
      senderName: author.getFullName,
      text: "",
    );
  }
}

import 'package:mahe_chat/domain/models/messages/message.dart';
import 'package:mahe_chat/domain/models/user/user.dart';

import 'reply_preview.dart';

class FileMessage extends Message {
  /// Creates a file message.
  FileMessage({
    required super.author,
    super.createdAt,
    required super.id,
    this.isLoading,
    super.metadata,
    this.mimeType,
    required this.name,
    super.remoteId,
    super.replyPreview,
    super.roomId,
    super.showStatus,
    required this.size,
    super.status,
    MessageType? type,
    super.updatedAt,
    required this.uri,
  }) : super(type: type ?? MessageType.file);

  /// Creates a file message from a map (decoded JSON).
  // factory FileMessage.fromJson(Map<String, dynamic> json) =>
  //     _$FileMessageFromJson(json);

  /// Specify whether the message content is currently being loaded.
  final bool? isLoading;

  /// Media type.
  final String? mimeType;

  /// The name of the file.
  final String name;

  /// Size of the file in bytes.
  final num size;

  /// The file source (either a remote URL or a local resource).
  final String uri;

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
      text: name,
    );
  }
}
